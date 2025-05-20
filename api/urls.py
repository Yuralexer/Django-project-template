from django.urls import path

from . import views

urlpatterns = [
    path("", views.getItems, name="getItems"),
    path("add/", views.addItem, name="addItem"),
]