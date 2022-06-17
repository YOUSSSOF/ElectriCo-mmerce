from uuid import uuid4
from django.db import models


# Create your models here.


class Product(models.Model):
    name = models.CharField(max_length=255)
    price = models.DecimalField(decimal_places=2, max_digits=8)
    description = models.TextField()
    image = models.ImageField(upload_to='products')
    last_upload = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.name

