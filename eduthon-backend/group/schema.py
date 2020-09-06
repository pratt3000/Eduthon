from graphene_django import DjangoObjectType
import graphene

from .models import GroupTasks, TeamModel
from graphene import relay
from graphene_django.filter import DjangoFilterConnectionField 
from graphene import Field
from graphene_django.forms.mutation import DjangoModelFormMutation
from .forms import TeamForm, GroupTasksForm

#queries here

class TeamPortfolio(DjangoObjectType):
    class Meta:
        model = TeamModel
        filter_fields = ['members', 'name']
        interfaces = (relay.Node,)


class GroupTasksModel(DjangoObjectType):
    class Meta:
        model = GroupTasks
        filter_fields = ['task', 'description', 'team']
        interfaces = (relay.Node,)


class Query(graphene.ObjectType):
    teams = relay.Node.Field(TeamPortfolio)
    all_teams = DjangoFilterConnectionField(TeamPortfolio)

    groupTasks = relay.Node.Field(GroupTasksModel)
    all_groupTasks = DjangoFilterConnectionField(GroupTasksModel)


#mutations

class TeamModelType(DjangoObjectType):
    class Meta:
        model = TeamModel


class TeamModelMutation(DjangoModelFormMutation):
    ent = Field(TeamPortfolio)

    class Meta:
        form_class = TeamForm


class GroupTaskType(DjangoObjectType):
    class Meta:
        model = GroupTasks


class GroupTaskMutation(DjangoModelFormMutation):
    ent = Field(GroupTasksModel)

    class Meta:
        form_class = GroupTasksForm

class Mutation(graphene.ObjectType):
    createTeam = TeamModelMutation.Field()
    createGroup = GroupTaskMutation.Field()