from rest_framework.decorators import api_view
from rest_framework.response import Response

from testApp.models import Item

from .serializers import ItemSerializer


@api_view(['GET'])
def getItems(request):
    items = Item.objects.all()
    serializer = ItemSerializer(items, many=True)
    return Response(data=serializer.data)

@api_view(['POST'])
def addItem(request):
    serializer = ItemSerializer(data=request.data)
    if serializer.is_valid():
        serializer.save()
    return Response(data=serializer.data)