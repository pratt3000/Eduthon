from django.db import models

from django.contrib.auth.models import AbstractUser
from group.models import TeamModel


class User(AbstractUser):
    email = models.EmailField()
    team = models.ForeignKey(TeamModel, on_delete = models.CASCADE, blank = True, null = True)
    isTeamAdmin = models.BooleanField(default= False)


class UserTokens(models.Model):
    user = models.ForeignKey(User, on_delete = models.CASCADE)
    jwt = models.CharField(max_length= 255)

