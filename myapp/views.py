import json
import urllib

from django.http import HttpResponse
from django.utils.crypto import get_random_string
from django.views.decorators.csrf import csrf_exempt

from .models import Entity


@csrf_exempt
def my_view(request):
    if request.method == 'GET':
        ens = Entity.objects.order_by('-id')[:20]
        data = {
            'entities': [{'name': en.name} for en in ens]
        }
        urllib.urlopen('http://git.dev.imap.so/users/sign_in')
        return HttpResponse(json.dumps(data))
    else:
        Entity(name=get_random_string()).save()
        return HttpResponse(json.dumps({'status': 'OK'}))
