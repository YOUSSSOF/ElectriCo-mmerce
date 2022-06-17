
from rest_framework.serializers import ModelSerializer, UUIDField, SerializerMethodField
from . import models


class ProductSerializer(ModelSerializer):
    class Meta:
        model = models.Product
        fields = '__all__'


