from graphene_django import DjangoObjectType
import graphene
from .forms import NewUserForm
from .models import User, UserTokens
from graphene import relay
from graphene_django.filter import DjangoFilterConnectionField 
from graphene import Field
from graphene_django.forms.mutation import DjangoModelFormMutation
import stream_chat

class UserModel(DjangoObjectType):
    class Meta:
        model = User
        filter_fields = ['username','email','team']
        interfaces = (relay.Node,)

class Query(graphene.ObjectType):
    users = relay.Node.Field(UserModel)
    all_users = DjangoFilterConnectionField(UserModel)


#mutations here
class UserType(DjangoObjectType):
    class Meta:
        model = User

class UserMutation(DjangoModelFormMutation):
    user = Field(UserType)
    
    class Meta:
        form_class = NewUserForm

class UserTokenType(DjangoObjectType):
    class Meta:
        model = UserTokens


class UserTokenMutation(graphene.Mutation):
    userToken = graphene.Field(UserTokenType)

    class Arguments:
        user = graphene.ID(required = True)
    
    def mutate(self, info, user):
        chat_client = stream_chat.StreamChat(api_key="whkwvq9maq97", api_secret="dgdh3ck6ff3x4n8wfnfdbwe2tva3acb4qvh4kc2ynmgw2yfqme9tv6fzses5gxdu")
        token = chat_client.create_token(user.username)

        usertoken = UserTokens(user = user, jwt = token)
        usertoken.save()

        return UserTokenMutation(userToken = usertoken)
        
        

class Mutation(graphene.ObjectType):
    create_user = UserMutation.Field()
    create_userToken = UserTokenMutation.Field()



# class CreateUser(graphene.Mutation):
#     user = graphene.Field(UserModel)

#     class Arguments:
#         username = graphene.String(required= True)
#         password = graphene.String(required= True)
#         email = graphene.String(required= True)
#         jwt = graphene.String(required= False)
#         team = graphene.String(required = False)
        
#     def mutate(self, info, username, password, email):

#         chat_client = stream_chat.StreamChat(api_key="whkwvq9maq97", api_secret="dgdh3ck6ff3x4n8wfnfdbwe2tva3acb4qvh4kc2ynmgw2yfqme9tv6fzses5gxdu")
#         token = chat_client.create_token(username)

#         user = User(username = username,
#         email = email, jwt = token, team = team
#         )
#         user.set_password(password)
#         user.save()

#         return CreateUser(user = user)  

# class Mutation(graphene.ObjectType):
#     create_user = CreateUser.Field()