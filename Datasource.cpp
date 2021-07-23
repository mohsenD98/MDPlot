#include "Datasource.h"

#include <QtCharts/QXYSeries>
#include <QtCharts/QAreaSeries>
#include <QtQuick/QQuickView>
#include <QtQuick/QQuickItem>
#include <QtCore/QDebug>
#include <QtCore/QRandomGenerator>
#include <QtCore/QtMath>

#define DATA_ROWS 5

QT_CHARTS_USE_NAMESPACE

Q_DECLARE_METATYPE(QAbstractSeries *)
Q_DECLARE_METATYPE(QAbstractAxis *)

DataSource::DataSource(QQuickView *appViewer, QObject *parent) :
    QObject(parent),
    m_appViewer(appViewer),
    m_index(-1)
{
    qRegisterMetaType<QAbstractSeries*>();
    qRegisterMetaType<QAbstractAxis*>();

    generateData();
}

double DataSource::sampleRate()
{
    return m_sampleRate;
}

void DataSource::setSampleRate(double value)
{
    if(m_sampleRate == value) return;
    m_sampleRate = value;
    emit sampleRateChanged(value);
}

double DataSource::minViewY()
{
    return m_minViewY;
}

void DataSource::setMinViewY(double value)
{
    if(m_minViewY == value)return;
    m_minViewY = value;
    emit minViewYChanged(value);
}

double DataSource::maxViewY()
{
    return m_maxViewY;
}

void DataSource::setMaxViewY(double value)
{
    if(m_maxViewY == value)return;
    m_maxViewY = value;
    emit maxViewYChanged(value);
}

void DataSource::update(QAbstractSeries *series)
{
    if (series) {
        QXYSeries *xySeries = static_cast<QXYSeries *>(series);
        m_index++;
        if (m_index > DATA_ROWS - 1)
            m_index = 0;

        QVector<QPointF> points = m_data.at(m_index);

        xySeries->replace(points);
    }
}

void DataSource::generateData()
{
    m_data.clear();

    for (int i(0); i < DATA_ROWS; i++) {

        QVector<QPointF> points;
        points.reserve(sampleRate());
        for (int j(0); j < sampleRate(); j++) {
            qreal x(0);
            qreal y(0);

            x = j;

            y = qSin(M_PI / 50 * j) + 0.5 + QRandomGenerator::global()->generateDouble();
            if (j > 2*sampleRate()/5 && j < 3*sampleRate()/5)
                y*=6;
            if(y>maxViewY())
            {
                setMaxViewY(1.3*y);
            }
            if(y<minViewY())
            {
                setMinViewY(1.3*y);
            }

            points.append(QPointF(x, y));
        }
        m_data.append(points);
    }
}
