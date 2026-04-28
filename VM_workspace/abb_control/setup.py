import os
from glob import glob
from setuptools import setup, find_packages

package_name = 'abb_control'

setup(
    name=package_name,
    version='0.0.0',
    packages=find_packages(exclude=['test']),
    data_files=[
        ('share/ament_index/resource_index/packages',
            ['resource/' + package_name]),
        ('share/' + package_name, ['package.xml']),
        # --- ESTA LÍNEA COPIA EL LANZADOR ---
        (os.path.join('share', package_name, 'launch'), glob('launch/*.launch.py')),
    ],
    install_requires=['setuptools'],
    zip_safe=True,
    maintainer='carles',
    maintainer_email='carles@todo.todo',
    description='Control package for ABB IRB 140',
    license='TODO: License declaration',
    tests_require=['pytest'],
    entry_points={
        'console_scripts': [
            # Aquí registramos tu script python
            'bailar = abb_control.simple_move:main',
        ],
    },
)
