from django.db import models
from django.contrib.auth.models import AbstractUser


# Create your models here.


class User(AbstractUser):
    profilePhoto = models.ImageField(upload_to='profiles', null=True)
