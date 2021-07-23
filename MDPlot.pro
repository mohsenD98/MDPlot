QT += charts qml quick

CONFIG += c++11

DEFINES += QT_DEPRECATED_WARNINGS

HEADERS += \
    Datasource.h

SOURCES += \
    main.cpp \
    Datasource.cpp

RESOURCES += qml.qrc

qnx: target.path = /tmp/$${TARGET}/bin

else: unix:!android: target.path = /opt/$${TARGET}/bin

!isEmpty(target.path): INSTALLS += target
