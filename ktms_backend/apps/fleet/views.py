# pyrefly: ignore [missing-import]
from rest_framework import views, permissions, status
from rest_framework.response import Response
from fleet.models import FleetVehicle, FleetTrip, FuelLog, VehicleType, TripStatus
from fleet.serializers import FleetVehicleSerializer, FleetTripSerializer, FuelLogSerializer

class FleetDashboardAPIView(views.APIView):
    permission_classes = [permissions.AllowAny]

    def get(self, request):
        vehicles = FleetVehicle.objects.all()
        trips = FleetTrip.objects.all().order_by('-created_at')
        fuel_logs = FuelLog.objects.all().order_by('-id')

        active_trips_count = trips.filter(status__in=[TripStatus.DISPATCHED, TripStatus.IN_TRANSIT]).count()
        delivered_trips_count = trips.filter(status=TripStatus.DELIVERED).count()

        return Response({
            "status": "success",
            "metrics": {
                "total_vehicles": vehicles.count(),
                "active_trips": active_trips_count,
                "delivered_trips": delivered_trips_count,
                "total_fuel_logs": fuel_logs.count()
            },
            "vehicles": FleetVehicleSerializer(vehicles, many=True).data,
            "recent_trips": FleetTripSerializer(trips[:10], many=True).data
        }, status=status.HTTP_200_OK)

class FleetVehicleListAPIView(views.APIView):
    permission_classes = [permissions.AllowAny]

    def get(self, request):
        vehicles = FleetVehicle.objects.all().order_by('-id')
        return Response({
            "status": "success",
            "count": vehicles.count(),
            "vehicles": FleetVehicleSerializer(vehicles, many=True).data
        }, status=status.HTTP_200_OK)

    def post(self, request):
        serializer = FleetVehicleSerializer(data=request.data)
        if not serializer.is_valid():
            return Response({"status": "error", "errors": serializer.errors}, status=status.HTTP_400_BAD_REQUEST)

        vehicle = serializer.save()
        return Response({
            "status": "success",
            "message": f"Vehicle {vehicle.registration_no} registered successfully!",
            "vehicle": FleetVehicleSerializer(vehicle).data
        }, status=status.HTTP_201_CREATED)

class PayloadMatcherAPIView(views.APIView):
    permission_classes = [permissions.AllowAny]

    def post(self, request):
        weight_kg = float(request.data.get('weight_kg', 0))
        suggested_vehicles = FleetVehicle.suggest_vehicle_for_weight(weight_kg)
        return Response({
            "status": "success",
            "payload_weight_kg": weight_kg,
            "recommended_vehicle_count": suggested_vehicles.count(),
            "vehicles": FleetVehicleSerializer(suggested_vehicles, many=True).data
        }, status=status.HTTP_200_OK)
