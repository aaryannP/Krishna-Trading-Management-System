# pyrefly: ignore [missing-import]
from rest_framework import views, permissions, status
from rest_framework.response import Response
from django.db.models import Sum, Count
from assets.models import Asset, AssetAssignment, AssetMaintenance, AssetCategory, AssetStatus
from assets.serializers import AssetSerializer, AssetAssignmentSerializer, AssetMaintenanceSerializer

class AssetListCreateAPIView(views.APIView):
    permission_classes = [permissions.AllowAny]

    def get(self, request):
        assets = Asset.objects.all().order_by('-id')
        category_filter = request.query_params.get('category')
        status_filter = request.query_params.get('status')
        if category_filter:
            assets = assets.filter(category=category_filter)
        if status_filter:
            assets = assets.filter(status=status_filter)

        return Response({
            "status": "success",
            "count": assets.count(),
            "assets": AssetSerializer(assets, many=True).data
        }, status=status.HTTP_200_OK)

    def post(self, request):
        data = request.data.copy()
        if not data.get('asset_code'):
            next_id = (Asset.objects.aggregate(max_id=models.Max('id'))['max_id'] or 0) + 1001
            data['asset_code'] = f"AST-{next_id}"

        serializer = AssetSerializer(data=data)
        if not serializer.is_valid():
            return Response({"status": "error", "errors": serializer.errors}, status=status.HTTP_400_BAD_REQUEST)

        asset = serializer.save()
        return Response({
            "status": "success",
            "message": f"Asset '{asset.name}' [{asset.asset_code}] registered successfully!",
            "asset": AssetSerializer(asset).data
        }, status=status.HTTP_201_CREATED)

class AssetDashboardAPIView(views.APIView):
    permission_classes = [permissions.AllowAny]

    def get(self, request):
        assets = Asset.objects.all()
        total_count = assets.count()
        total_valuation = assets.aggregate(val=Sum('purchase_cost'))['val'] or 0.00
        available_count = assets.filter(status=AssetStatus.AVAILABLE).count()
        assigned_count = assets.filter(status=AssetStatus.ASSIGNED).count()
        maintenance_count = assets.filter(status=AssetStatus.MAINTENANCE).count()
        damaged_count = assets.filter(status=AssetStatus.DAMAGED).count()

        category_counts = {}
        for cat_choice, cat_label in AssetCategory.choices:
            cnt = assets.filter(category=cat_choice).count()
            if cnt > 0:
                category_counts[cat_label] = cnt

        recent_assets = assets.order_by('-id')[:5]

        return Response({
            "status": "success",
            "metrics": {
                "total_count": total_count,
                "total_valuation": float(total_valuation),
                "available_count": available_count,
                "assigned_count": assigned_count,
                "maintenance_count": maintenance_count,
                "damaged_count": damaged_count,
                "category_breakdown": category_counts
            },
            "recent_assets": AssetSerializer(recent_assets, many=True).data
        }, status=status.HTTP_200_OK)

class AssetAssignmentAPIView(views.APIView):
    permission_classes = [permissions.AllowAny]

    def get(self, request):
        assignments = AssetAssignment.objects.all().order_by('-id')
        return Response({
            "status": "success",
            "count": assignments.count(),
            "assignments": AssetAssignmentSerializer(assignments, many=True).data
        }, status=status.HTTP_200_OK)

    def post(self, request):
        serializer = AssetAssignmentSerializer(data=request.data)
        if not serializer.is_valid():
            return Response({"status": "error", "errors": serializer.errors}, status=status.HTTP_400_BAD_REQUEST)

        assignment = serializer.save()
        # Automatically update asset status to ASSIGNED
        assignment.asset.status = AssetStatus.ASSIGNED
        assignment.asset.save()

        return Response({
            "status": "success",
            "message": f"Asset {assignment.asset.name} assigned to {assignment.user.get_full_name() or assignment.user.username}!",
            "assignment": AssetAssignmentSerializer(assignment).data
        }, status=status.HTTP_201_CREATED)

class AssetMaintenanceAPIView(views.APIView):
    permission_classes = [permissions.AllowAny]

    def get(self, request):
        logs = AssetMaintenance.objects.all().order_by('-id')
        return Response({
            "status": "success",
            "count": logs.count(),
            "logs": AssetMaintenanceSerializer(logs, many=True).data
        }, status=status.HTTP_200_OK)

    def post(self, request):
        serializer = AssetMaintenanceSerializer(data=request.data)
        if not serializer.is_valid():
            return Response({"status": "error", "errors": serializer.errors}, status=status.HTTP_400_BAD_REQUEST)

        log = serializer.save()
        # Automatically update asset status to MAINTENANCE
        log.asset.status = AssetStatus.MAINTENANCE
        log.asset.save()

        return Response({
            "status": "success",
            "message": f"Maintenance log for {log.asset.name} recorded!",
            "log": AssetMaintenanceSerializer(log).data
        }, status=status.HTTP_201_CREATED)
