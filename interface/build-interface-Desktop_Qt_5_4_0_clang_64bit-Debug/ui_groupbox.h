/********************************************************************************
** Form generated from reading UI file 'groupbox.ui'
**
** Created by: Qt User Interface Compiler version 5.4.0
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_GROUPBOX_H
#define UI_GROUPBOX_H

#include <QtCore/QVariant>
#include <QtWidgets/QAction>
#include <QtWidgets/QApplication>
#include <QtWidgets/QButtonGroup>
#include <QtWidgets/QGraphicsView>
#include <QtWidgets/QGroupBox>
#include <QtWidgets/QHeaderView>
#include <QtWidgets/QProgressBar>
#include <QtWidgets/QPushButton>

QT_BEGIN_NAMESPACE

class Ui_GroupBox
{
public:
    QGraphicsView *graphicsView;
    QProgressBar *progressBar;
    QPushButton *pushButton;

    void setupUi(QGroupBox *GroupBox)
    {
        if (GroupBox->objectName().isEmpty())
            GroupBox->setObjectName(QStringLiteral("GroupBox"));
        GroupBox->resize(460, 356);
        graphicsView = new QGraphicsView(GroupBox);
        graphicsView->setObjectName(QStringLiteral("graphicsView"));
        graphicsView->setGeometry(QRect(15, 90, 431, 251));
        progressBar = new QProgressBar(GroupBox);
        progressBar->setObjectName(QStringLiteral("progressBar"));
        progressBar->setGeometry(QRect(320, 60, 118, 23));
        progressBar->setValue(24);
        pushButton = new QPushButton(GroupBox);
        pushButton->setObjectName(QStringLiteral("pushButton"));
        pushButton->setGeometry(QRect(320, 30, 115, 32));

        retranslateUi(GroupBox);

        QMetaObject::connectSlotsByName(GroupBox);
    } // setupUi

    void retranslateUi(QGroupBox *GroupBox)
    {
        GroupBox->setWindowTitle(QApplication::translate("GroupBox", "GroupBox", 0));
        GroupBox->setTitle(QApplication::translate("GroupBox", "GroupBox", 0));
        pushButton->setText(QApplication::translate("GroupBox", "Go", 0));
    } // retranslateUi

};

namespace Ui {
    class GroupBox: public Ui_GroupBox {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_GROUPBOX_H
