from django.db import models
from testApp.models import User
from group.models import GroupTasks

class IndvTask(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    task = models.CharField(max_length=288)
    desc = models.TextField(null = True)
    prog = models.IntegerField(default= 0)

    def __str__(self):
        return str(self.prog)

    class Meta:
        verbose_name_plural = "Tasks"

class ProgressModel(models.Model):
    user = models.ForeignKey(User, on_delete = models.CASCADE)
    task = models.ForeignKey(GroupTasks, on_delete =models.CASCADE)
    progress = models.IntegerField(default= 0 )

    def __str__(self):
        return str(self.progress)

    class Meta:
        verbose_name_plural = "Progress"
