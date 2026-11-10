#!/usr/bin/env python3
"""Instala os arquivos oficiais obtidos pelo usuário, sem substituir SDK existente."""
import argparse
import os
from pathlib import Path, PurePosixPath
import shutil
import stat
import subprocess
import tarfile
import tempfile
import zipfile


def install(jdk_archive, wildfly_archive, sdk):
    if os.name != 'posix':
        raise SystemExit('Execute com Python 3.12+ no Ubuntu, não no Windows.')
    if not hasattr(tarfile, 'data_filter'):
        raise SystemExit('É necessário Python 3.12+ com suporte ao filtro de extração data.')
    sdk = sdk.expanduser().resolve()
    for name in ('jdk8', 'wildfly'):
        if (sdk / name).exists() or (sdk / name).is_symlink():
            raise SystemExit(f'SDK existente preservado: {sdk / name}')
    sdk.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix='.sdk-stage-', dir=sdk) as temporary:
        stage = Path(temporary)
        java_stage = stage / 'java'
        wildfly_stage = stage / 'server'
        java_stage.mkdir()
        wildfly_stage.mkdir()
        with tarfile.open(jdk_archive, 'r:gz') as archive:
            archive.extractall(java_stage, filter='data')
        java_bins = list(java_stage.glob('*/bin/java'))
        if len(java_bins) != 1:
            raise SystemExit('Estrutura inesperada no JDK. Use o pacote Linux x64 oficial.')
        java_root = java_bins[0].parent.parent
        if not (java_root / 'bin/javac').is_file():
            raise SystemExit('Pacote sem javac; é necessário JDK, não apenas JRE.')
        version = subprocess.run([str(java_bins[0]), '-version'], capture_output=True, text=True, check=True)
        if 'version "1.8.' not in version.stderr:
            raise SystemExit('Este ambiente requer JDK 8.')
        with zipfile.ZipFile(wildfly_archive) as archive:
            for member in archive.infolist():
                path = PurePosixPath(member.filename)
                mode = member.external_attr >> 16
                if path.is_absolute() or '..' in path.parts or '\\' in member.filename or ':' in member.filename or stat.S_ISLNK(mode):
                    raise SystemExit('Caminho ou link não permitido no ZIP.')
            archive.extractall(wildfly_stage)
        servers = list(wildfly_stage.glob('*/bin/standalone.sh'))
        if len(servers) != 1:
            raise SystemExit('Estrutura inesperada no WildFly Sankhya.')
        server = servers[0].parent.parent
        if not (server / 'standalone/deployments/wpm.war').is_file():
            raise SystemExit('WPM ausente. Use o WildFly da Central Sankhya.')
        configuration = server / 'bin/standalone.conf'
        original = configuration.read_bytes()
        if b'-Xms2048m' not in original:
            raise SystemExit('Configuração de memória diferente do pacote validado. Revise antes de instalar.')
        (server / 'bin/standalone.conf.vendor-original').write_bytes(original)
        configuration.write_bytes(original.replace(b'-Xms2048m', b'-Xms512m'))
        for script in (server / 'bin').glob('*.sh'):
            script.chmod(script.stat().st_mode | 0o111)
        shutil.move(str(java_root), str(sdk / 'jdk8'))
        shutil.move(str(server), str(sdk / 'wildfly'))
    print(f'SDK instalado em {sdk}. Heap inicial ajustado para 512 MB; demais opções preservadas.')


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--jdk', type=Path, required=True)
    parser.add_argument('--wildfly', type=Path, required=True)
    parser.add_argument('--destination', type=Path, default=Path(os.environ.get('SANKHYA_SDK_HOME', str(Path.home() / 'sankhya-sdk'))))
    arguments = parser.parse_args()
    install(arguments.jdk, arguments.wildfly, arguments.destination)
