from rest_framework.viewsets import ModelViewSet
from .models import Product
from .serializers import ProductSerializer
from rest_framework.permissions import IsAdminUser, IsAuthenticated

# Create your views here.


class ProductViewSet(ModelViewSet):
    queryset = Product.objects.all()
    serializer_class = ProductSerializer
    permission_classes = []

    def get_permissions(self):
        if self.request.method == "DELETE" or self.request.method == "PATCH" or self.request.method == "POST":
            self.permission_classes = [IsAdminUser]
        return super(ProductViewSet, self).get_permissions()
