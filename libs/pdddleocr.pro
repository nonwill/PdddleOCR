
CONFIG -= qt

TEMPLATE = lib

TARGET = pdddleocr


mac:CONFIG += static

win32:DEFINES += PPOCR_LIBRARY
#win32:DEFINES += PPOCR_benchmark_ENABLED
#win32:DEFINES += PPOCR_gflags_ENABLED
#CONFIG += Clipper2Lib

include($$PWD/../../nwDeployed/nwDeployed.pri)

CONFIG += ppmkl

# https://zhuanlan.zhihu.com/p/680229436
PPOCR_ROOT_DIR = $$PWD/..
PPOCR_DEPS_DIR = $$PWD/../deps

OPENCV_DIR = $${PPOCR_DEPS_DIR}/opencv-3.4.20
PADDLE_LIB = $${PPOCR_DEPS_DIR}/paddle_inference-2.6.2
#PADDLE_LIB = $${PPOCR_ROOT_DIR}/paddle_inference-3.0.0rc0


INCLUDEPATH += $${PPOCR_ROOT_DIR} \
    $${PPOCR_ROOT_DIR}/include \
    $${OPENCV_DIR}/include \
    $${PADDLE_LIB}/paddle/include \
    $${NWDEP_DIR}/getopt

Clipper2Lib {
    DEFINES += ClipperLib_Version_2
    msvc*:QMAKE_CXXFLAGS = -std:c++17
    INCLUDEPATH += $${NWDEP_DIR}/Clipper2/include
    LIBS += -lClipper2
} else {
    SOURCES += $${PPOCR_ROOT_DIR}/src/clipper.cpp
    HEADERS += $${PPOCR_ROOT_DIR}/include/clipper.h \
}

# PaddleOCR-2.9.1

SOURCES += \
    $${PPOCR_ROOT_DIR}/src/args.cpp \
    $${PPOCR_ROOT_DIR}/src/ocr_cls.cpp \
    $${PPOCR_ROOT_DIR}/src/ocr_det.cpp \
    $${PPOCR_ROOT_DIR}/src/ocr_rec.cpp \
    $${PPOCR_ROOT_DIR}/src/paddleocr.cpp \
    $${PPOCR_ROOT_DIR}/src/paddlestructure.cpp \
    $${PPOCR_ROOT_DIR}/src/postprocess_op.cpp \
    $${PPOCR_ROOT_DIR}/src/preprocess_op.cpp \
    $${PPOCR_ROOT_DIR}/src/structure_layout.cpp \
    $${PPOCR_ROOT_DIR}/src/structure_table.cpp \
    $${PPOCR_ROOT_DIR}/src/utility.cpp

HEADERS += $${PPOCR_ROOT_DIR}/include/ppocr_api.h \
    $${PPOCR_ROOT_DIR}/include/args.h \
    $${PPOCR_ROOT_DIR}/include/ocr_cls.h \
    $${PPOCR_ROOT_DIR}/include/ocr_det.h \
    $${PPOCR_ROOT_DIR}/include/ocr_rec.h \
    $${PPOCR_ROOT_DIR}/include/paddleocr.h \
    $${PPOCR_ROOT_DIR}/include/paddlestructure.h \
    $${PPOCR_ROOT_DIR}/include/postprocess_op.h \
    $${PPOCR_ROOT_DIR}/include/preprocess_op.h \
    $${PPOCR_ROOT_DIR}/include/structure_layout.h \
    $${PPOCR_ROOT_DIR}/include/structure_table.h \
    $${PPOCR_ROOT_DIR}/include/utility.h

win32:equals(ARCHITECTURE,x64) {
  msvc* {
    LIBS += -L$${OPENCV_DIR}/x64/vc16/lib
    _ = $$nwCopyFileToDir($${OPENCV_DIR}/x64/vc16/bin/*.dll,$${DESTDIR})
  } else {
    LIBS += -L$${OPENCV_DIR}/x64/mingw/lib
    _ = $$nwCopyFileToDir($${OPENCV_DIR}/x64/mingw/bin/*.dll,$${DESTDIR})
  }

  ppmkl {
    _ = $$nwCopyFileToDir($${PPOCR_DEPS_DIR}/oneDNN-3.6.2/bin/dnnl.dll,$${DESTDIR},mkldnn.dll)
    _ = $$nwCopyFileToDir($${PPOCR_DEPS_DIR}/mklml/lib/win-x64/native/*.dll,$${DESTDIR})
    _ = $$nwCopyFileToDir($${PADDLE_LIB}/paddle/lib/mkl/*.dll,$${DESTDIR})
    _ = $$nwCopyFileToDir($${PADDLE_LIB}/paddle/lib/mkl/*.manifest,$${DESTDIR})
    LIBS += -L$${PADDLE_LIB}/paddle/lib/mkl
  } else {
    _ = $$nwCopyFileToDir($${PPOCR_DEPS_DIR}/OpenBLAS-0.3.29/bin/openblas.dll,$${DESTDIR})
    _ = $$nwCopyFileToDir($${PADDLE_LIB}/paddle/lib/*.dll,$${DESTDIR})
    _ = $$nwCopyFileToDir($${PADDLE_LIB}/paddle/lib/*.manifest,$${DESTDIR})
    LIBS += -L$${PADDLE_LIB}/paddle/lib
  }
}

LIBS += -lpaddle_inference -lopencv_world3420

win32:LIBS += -lgetopt

