To install driver -
        make inst (The Makefile will check the module and compile and link it automatically. It will also remove
                   the loaded USB-Serial driver)

To uninstall driver -
        make uninst

To uninstall all drivers (including base driver) -
        make uninst_all

To remove module (*.o) files -
        make clean
