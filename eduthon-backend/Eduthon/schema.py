import graphene
import graphql_jwt
import testApp.schema
import indv.schema
import group.schema

class Query(testApp.schema.Query, indv.schema.Query, group.schema.Query ,graphene.ObjectType):
    pass

class Mutation(indv.schema.Mutation, group.schema.Mutation,testApp.schema.Mutation , graphene.ObjectType):
    token_auth = graphql_jwt.ObtainJSONWebToken.Field()
    verify_token = graphql_jwt.Verify.Field()
    refresh_token = graphql_jwt.Refresh.Field()
    pass

schema = graphene.Schema(query=Query, mutation = Mutation)