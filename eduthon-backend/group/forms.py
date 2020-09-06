from django.forms import ModelForm
from group.models import TeamModel, GroupTasks

class TeamForm(ModelForm):
    class Meta:
        model = TeamModel
        fields = '__all__'

class GroupTasksForm(ModelForm):
    class Meta:
        model = GroupTasks
        fields = '__all__'
