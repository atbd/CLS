# -*- coding: utf-8 -*-

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
import datetime as dt
import Utilities.calcul as ut

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
        GroupBox.setFixedSize(GroupBox.size())

        # QWidget
        self.fig = Figure()
        self.canvas = FigureCanvas(self.fig)

        self.widget = QtGui.QWidget(GroupBox)
        self.widget.setGeometry(QtCore.QRect(-1, 99, 661, 431))
        self.widget.setAutoFillBackground(True)
        self.widget.setObjectName(_fromUtf8("widget"))

        self.layout = QtGui.QVBoxLayout(self.widget)
        self.mpl_toolbar = NavigationToolbar(self.canvas, self.widget, coordinates = False)

        self.layout.addWidget(self.canvas)
        self.layout.addWidget(self.mpl_toolbar)
        rect = 0,0.05,1,0.9
        self.axes = self.fig.add_axes(rect)
        self.widget.setLayout(self.layout)

        # date&time start
        self.dateTimeEditStart = QtGui.QDateTimeEdit(GroupBox)
        self.dateTimeEditStart.setGeometry(QtCore.QRect(210, 40, 194, 24))
        self.dateTimeEditStart.setObjectName(_fromUtf8("dateTimeEditStart"))

        # date&time end
        self.dateTimeEditEnd = QtGui.QDateTimeEdit(GroupBox)
        self.dateTimeEditEnd.setGeometry(QtCore.QRect(440, 40, 194, 24))
        self.dateTimeEditEnd.setObjectName(_fromUtf8("dateTimeEditEnd"))

        # Bouton choix fichier
        self.fileButton = QtGui.QPushButton(GroupBox)
        self.fileButton.setGeometry(QtCore.QRect(0, 20, 115, 32))
        self.fileButton.setObjectName(_fromUtf8("fileButton"))

        self.dejaVu = 0

        def buttonFct():
            #self.canvas.remove()
            path = QtGui.QFileDialog.getOpenFileNames(None, "Choix un ou plusieurs fichiers", "", "(*.DIAG *.DS *.CSV)")

            if path != []:
                start = self.dateTimeEditStart.dateTime().toPyDateTime()
                end = self.dateTimeEditEnd.dateTime().toPyDateTime()
                ref = dt.datetime(2000, 1, 1, 0, 0, 0)  # important
                startSecond = (start - ref).total_seconds()
                endSecond = (end - ref).total_seconds()

                if startSecond > endSecond:
                    startSecond, endSecond = endSecond, startSecond

                listLatitudes = []
                listLongitudes = []

                for i in range(len(path)):
                    lats, lons = gui.toutEnUn(path[i], startSecond, endSecond)
                    listLatitudes.append(lats)
                    listLongitudes.append(lons)

                if self.dejaVu == 0:
                    monLon = sum(listLongitudes[0])/len(listLongitudes[0])
                    monLat = sum(listLatitudes[0])/len(listLatitudes[0])
                    self.dejaVu = 1

                    self.m = Basemap(width=12000000,height=9000000,projection='lcc', lat_0=monLat, lon_0=monLon, resolution=None, ax=self.axes)
                    self.m.etopo()      
                    
                    self.m.drawmeridians(np.arange(10,351,30), labels=[0,1,1,0])
                    self.m.drawparallels(np.arange(0,90,10), labels=[1,0,0,1])

                for i in range(len(listLatitudes)):
                    x,y = self.m(listLongitudes[i],listLatitudes[i])
                    self.m.plot(x,y,'-')

                self.canvas.draw()

        self.fileButton.clicked.connect(buttonFct)
        
        # Bouton sauvegarder
        self.saveButton = QtGui.QPushButton(GroupBox)
        self.saveButton.setGeometry(QtCore.QRect(0, 60, 115, 32))
        self.saveButton.setObjectName(_fromUtf8("saveButton"))
        
        # label end
        self.labelEnd = QtGui.QLabel(GroupBox)
        self.labelEnd.setGeometry(QtCore.QRect(500, 20, 59, 16))
        self.labelEnd.setObjectName(_fromUtf8("labelEnd"))
        
        # label start
        self.labelStart = QtGui.QLabel(GroupBox)
        self.labelStart.setGeometry(QtCore.QRect(260, 20, 59, 16))
        self.labelStart.setAlignment(QtCore.Qt.AlignCenter)
        self.labelStart.setObjectName(_fromUtf8("labelStart"))

        self.retranslateUi(GroupBox)
        QtCore.QMetaObject.connectSlotsByName(GroupBox)

    def retranslateUi(self, GroupBox):
        GroupBox.setWindowTitle(_translate("GroupBox", "GroupBox", None))
        GroupBox.setTitle(_translate("GroupBox", "GroupBox", None))
        self.fileButton.setText(_translate("GroupBox", "File(s)", None))
        self.saveButton.setText(_translate("GroupBox", "Save", None))
        self.labelEnd.setText(_translate("GroupBox", "End", None))
        self.labelStart.setText(_translate("GroupBox", "Start", None))


if __name__ == "__main__":
    import sys
    app = QtGui.QApplication(sys.argv)
    GroupBox = QtGui.QGroupBox()
    ui = Ui_GroupBox()
    ui.setupUi(GroupBox)
    GroupBox.show()
    sys.exit(app.exec_())

