#pragma once

#include <QtCore/QObject>
#include <QtCharts/QAbstractSeries>

QT_BEGIN_NAMESPACE
class QQuickView;
QT_END_NAMESPACE

QT_CHARTS_USE_NAMESPACE

class DataSource : public QObject
{
    Q_OBJECT
    Q_PROPERTY(double sampleRate READ sampleRate WRITE setSampleRate NOTIFY sampleRateChanged)
    Q_PROPERTY(double minViewY READ minViewY WRITE setMinViewY NOTIFY minViewYChanged)
    Q_PROPERTY(double maxViewY READ maxViewY WRITE setMaxViewY NOTIFY maxViewYChanged)

public:
    explicit DataSource(QQuickView *appViewer, QObject *parent = 0);

    double sampleRate();
    void setSampleRate(double value);

    double minViewY();
    void setMinViewY(double value);

    double maxViewY();
    void setMaxViewY(double value);
public slots:
    void generateData();
    void update(QAbstractSeries *series);

signals:
    void sampleRateChanged(double value);
    void maxViewYChanged(double value);
    void minViewYChanged(double value);

private:
    QQuickView *m_appViewer;
    QList<QVector<QPointF> > m_data;
    int m_index;
    double m_sampleRate=1024;
    double  m_maxViewY = 0;
    double  m_minViewY = 0;
};
