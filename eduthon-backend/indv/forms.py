from django.forms import ModelForm
from indv.models import IndvTask, ProgressModel

class IndvTaskForm(ModelForm):
    class Meta:
        model = IndvTask
        fields = '__all__'

class ProgressForm(ModelForm):
    class Meta:
        model = ProgressModel
        fields = '__all__'

