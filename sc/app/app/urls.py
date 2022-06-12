from django.contrib import admin
from django.urls import path
from api import views

urlpatterns = [
    path("", views.sc, name="sc"),
    path("admin/", admin.site.urls),
]
