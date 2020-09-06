from django.db import models

class TeamModel(models.Model):
    members = models.IntegerField(default=0)
    name = models.CharField(max_length=40)

    def __str__(self):
        return self.name

    class Meta:
        verbose_name_plural = "Teams"

class GroupTasks(models.Model):
    task = models.CharField(max_length=288)
    description = models.TextField(null =True)
    team  = models.ForeignKey(TeamModel, on_delete=models.CASCADE)

    def __str__(self):
        return self.task

    class Meta:
        verbose_name_plural = "Group_Tasks"


# class ProgressModel(models.Model):
#     User = models.ForeignKey(User, on_delete = models.CASCADE)
#     task = models.ForeignKey(GroupTasks, on_delete =models.CASCADE)
#     progress = models.IntegerField()

#     def __str__(self):
#         return self.User

#     class Meta:
#         verbose_name_plural = "Progress"
