#!/usr/bin/python
# -*-coding:utf-8 -*

import sys
from PyQt5.QtCore import *
from PyQt5.QtGui import *
from PyQt5.QtWidgets import *
from interface.groupbox import Ui_GroupBox

class interfaceApplication(QGroupBox):
	def __init__(self, parent=None):
		super(interfaceApplication, self).__init__(parent)
		self.createWidgets()

	def createWidgets(self):
		self.ui = Ui_GroupBox()
		self.ui.setupUi(self)

if __name__ == "__main__":
	app = QApplication(sys.argv)
	myApp = interfaceApplication()
	myApp.show()
	sys.exit(app.exec_())
