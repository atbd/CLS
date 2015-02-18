# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file 'groupbox.ui'
#
# Created: Tue Feb 17 15:18:52 2015
#      by: PyQt4 UI code generator 4.11.3
#
# WARNING! All changes made in this file will be lost!

import sys
import os
from matplotlib.backends import qt4_compat
from PyQt4 import QtGui, QtCore
from matplotlib.backends.backend_qt4agg import FigureCanvasQTAgg as FigureCanvas
from matplotlib.backends.backend_qt4agg import NavigationToolbar2QTAgg as NavigationToolbar
from matplotlib.figure import Figure
from mpl_toolkits.basemap import Basemap
import numpy as np

# bibli perso
import interface.fctInterface as gui

try:
    _fromUtf8 = QtCore.QString.fromUtf8
except AttributeError:
    def _fromUtf8(s):
        return s

try:
    _encoding = QtGui.QApplication.UnicodeUTF8
    def _translate(context, text, disambig):
        return QtGui.QApplication.translate(context, text, disambig, _encoding)
except AttributeError:
    def _translate(context, text, disambig):
        return QtGui.QApplication.translate(context, text, disambig)

class Ui_GroupBox(object):
    def setupUi(self, GroupBox):
        GroupBox.setObjectName(_fromUtf8("GroupBox"))
        GroupBox.resize(661, 532)

        self.fileButton = QtGui.QPushButton(GroupBox)
        self.fileButton.setGeometry(QtCore.QRect(280, 50, 115, 32))
        self.fileButton.setObjectName(_fromUtf8("fileButton"))

        self.fig = Figure()
        self.canvas = FigureCanvas(self.fig)

        self.widget = QtGui.QWidget(GroupBox)
        self.widget.setGeometry(QtCore.QRect(-1, 99, 661, 431))
        self.widget.setObjectName(_fromUtf8("widget"))

        self.layout = QtGui.QVBoxLayout(self.widget)
        self.mpl_toolbar = NavigationToolbar(self.canvas, self.widget, coordinates = False)

        self.layout.addWidget(self.canvas)
        self.layout.addWidget(self.mpl_toolbar)
        rect = 0,0.05,1,0.9
        self.axes = self.fig.add_axes(rect)
        self.widget.setLayout(self.layout)

        def buttonFct():
            self.canvas.clean()
            path = QtGui.QFileDialog.getOpenFileNames(None, "Choix un ou plusieurs fichiers", "", "(*.DIAG *.DS *.CSV)")

            if path != []:
                listLatitudes = []
                listLongitudes = []

                for i in range(len(path)):
                    lats, lons = gui.toutEnUn(path[i])
                    listLatitudes.append(lats)
                    listLongitudes.append(lons)

                monLon = sum(listLongitudes[0])/len(listLongitudes[0])
                monLat = sum(listLatitudes[0])/len(listLatitudes[0])

                m = Basemap(width=12000000,height=9000000,projection='lcc', lat_0=monLat, lon_0=monLon, resolution=None, ax=self.axes)
                m.etopo()        
                
                m.drawmeridians(np.arange(10,351,30), labels=[0,1,1,0])
                m.drawparallels(np.arange(0,90,10), labels=[1,0,0,1])

                for i in range(len(listLatitudes)):
                    x,y = m(listLongitudes[i],listLatitudes[i])
                    m.plot(x,y,'-')

                self.canvas.draw()

        self.fileButton.clicked.connect(buttonFct)

        self.retranslateUi(GroupBox)
        QtCore.QMetaObject.connectSlotsByName(GroupBox)

    def retranslateUi(self, GroupBox):
        GroupBox.setWindowTitle(_translate("GroupBox", "GroupBox", None))
        GroupBox.setTitle(_translate("GroupBox", "GroupBox", None))
        self.fileButton.setText(_translate("GroupBox", "File(s)", None))


if __name__ == "__main__":
    import sys
    app = QtGui.QApplication(sys.argv)
    GroupBox = QtGui.QGroupBox()
    ui = Ui_GroupBox()
    ui.setupUi(GroupBox)
    GroupBox.show()
    sys.exit(app.exec_())

