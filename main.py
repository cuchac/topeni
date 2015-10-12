import sys
from PyQt5.QtCore import QUrl
from PyQt5.QtWidgets import QApplication
from PyQt5.QtQml import QQmlApplicationEngine, qmlRegisterType
from data_source import DataSource

# Main Function
if __name__ == '__main__':
    # Create main app
    app = QApplication(sys.argv)

    qmlRegisterType(DataSource, 'DataSource', 1, 0, 'DataSource')

    engine = QQmlApplicationEngine()
    engine.load(QUrl('main.qml'))

    app.exec_()
    sys.exit()