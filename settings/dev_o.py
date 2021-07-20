from .base import *  # noqa

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = True

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = 'x9s5$nsz@jo6t#6loqho$jbwhlp3@ij0cu%t!(419%j=(of=y-'

ALLOWED_HOSTS = ['name_host']

EMAIL_BACKEND = 'django.core.mail.backends.console.EmailBackend'

WAGTAIL_CACHE = False

try:
    from .local_settings import *  # noqa
except ImportError:
    pass
