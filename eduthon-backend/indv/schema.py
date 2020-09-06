from graphene_django import DjangoObjectType
import graphene

from .models import IndvTask, ProgressModel
from graphene import relay
from graphene_django.filter import DjangoFilterConnectionField 
from graphene import Field
from graphene_django.forms.mutation import DjangoModelFormMutation
from .forms import  IndvTaskForm,ProgressForm

#queries here
class IndvTaskModel(DjangoObjectType):
    class Meta:
        model = IndvTask
        filter_fields = ['user','task', 'desc', 'prog']
        interfaces = (relay.Node,)


class ProgressModelObject(DjangoObjectType):
    class Meta:
        model = ProgressModel
        filter_fields = ['user','task', 'progress']
        interfaces = (relay.Node,)



class Query(graphene.ObjectType):
    indvtasks = relay.Node.Field(IndvTaskModel)
    all_indvtasks = DjangoFilterConnectionField(IndvTaskModel)

    progress = relay.Node.Field(ProgressModelObject)
    all_progressModel = DjangoFilterConnectionField(ProgressModelObject)

#Mutations here :
class IndvTaskType(DjangoObjectType):
    class Meta:
        model = IndvTask


class IndvTaskMutation(DjangoModelFormMutation):
    ent = Field(IndvTaskType)

    class Meta:
        form_class = IndvTaskForm


class ProgressModelType(DjangoObjectType):
    class Meta:
        model = ProgressModel


class ProgressModelMutation(DjangoModelFormMutation):
    ent = Field(ProgressModelType)

    class Meta:
        form_class = ProgressForm

#progress mutations
class AppendIndvTaskProg(graphene.Mutation):
    indvtask = Field(IndvTaskType)

    class Arguments :
        #user  = graphene.ID(required = False)
        task = graphene.ID(required = True) #global id of indv Task
        prog = graphene.Int(required = True)
    
    def mutate(self, info, task, prog):
        task_object = IndvTask.objects.get(task = task)
        task_object.prog = prog
        task_object.save()

        return AppendIndvTaskProg(indvtask = task_object)


class UpdateProgress(graphene.Mutation):
    progress_group = Field(ProgressModelType)

    class Arguments:
        obj_primarykey = graphene.ID(required = True) 
        progress = graphene.Int()

    def mutate(info,self, obj_primarykey, progress):
        progress_object = ProgressModel.objects.get(pk = obj_primarykey)
        progress_object.progress = progress
        progress_object.save()

        return UpdateProgress(progress_group = progress_object)



class Mutation(graphene.ObjectType):
    createIndvTask = IndvTaskMutation.Field()
    addProgress = ProgressModelMutation.Field()

    appendIndvProg =AppendIndvTaskProg.Field()
    updateProgress = UpdateProgress.Field()