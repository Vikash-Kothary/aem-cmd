# coding: utf-8
from StringIO import StringIO

from httmock import HTTMock
from mock import patch
from nose.tools import eq_

import acmd.assets
import acmd.jcr.path
from acmd import Server, OK
from mock_service import MockAssetsService, MockAssetsHttpService

@patch('sys.stdout', new_callable=StringIO)
@patch('sys.stderr', new_callable=StringIO)
def test_find_assets(stderr, stdout):
    asset_service = MockAssetsService()
    asset_service.add_folder("/", "myfolder")
    asset_service.add_asset("/", "root_asset.jpg")
    asset_service.add_asset("/myfolder", "myasset.jpg")
    http_service = MockAssetsHttpService(asset_service)

    with HTTMock(http_service):
        server = Server('localhost')
        api = acmd.assets.AssetsApi(server)

        status, data = api.find("/")
        eq_(OK, status)
        eq_(2, len(data))

        eq_('/', data[0]['properties']['path'])
        eq_('root_asset.jpg', data[0]['properties']['name'])

        eq_('/myfolder', data[1]['properties']['path'])
        eq_('myasset.jpg', data[1]['properties']['name'])
