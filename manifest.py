from dxf import DXF

def auth(dxf, response):
    dxf.authenticate('cerna', 'e07abc928f90ffc6402a591f25390a8b68138f6d', response=response)

dxf = DXF('docker.pkg.github.com', 'cerna/machinekit-hal/cross-builder', auth)

aliases = dxf.list_aliases()
for alias in aliases:
    manifest = dxf.get_manifest(alias)
    print('Manifest pro: \n')
    print(manifest)