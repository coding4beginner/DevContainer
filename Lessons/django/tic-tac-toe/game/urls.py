


from . import views

from django.urls import include, path

urlpatterns = [
    path('', views.index, name='index'),
    path('game/move/', views.move , name='move'),
]
