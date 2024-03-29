"""backend_app URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/3.2/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path
# CONFIG 1
from drf_spectacular.views import (
    SpectacularAPIView,
    SpectacularSwaggerView,
)
# END 1

urlpatterns = [
    path('admin/', admin.site.urls),
    # CONFIG 1
    # Generate ther schema file to automate the docs
    path('api/schema/', SpectacularAPIView.as_view(), name='api-schema'),
    # Set what schema to use when downloading swagger
    path(
        'api/docs/',
        SpectacularSwaggerView.as_view(url_name='api-schema'),
        name='api-docs',
    )

    # END 1
]
