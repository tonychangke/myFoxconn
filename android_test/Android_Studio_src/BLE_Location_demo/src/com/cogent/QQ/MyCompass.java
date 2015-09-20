package com.cogent.QQ;

/**
 * Created by mayintong on 2015/8/6.
 */

import android.app.Activity;
import android.content.Context;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;

import java.util.List;

public class MyCompass extends Activity implements SensorEventListener
{
    //private CompassView    _compassView;
    private boolean        mRegisteredSensor;
    //定义SensorManager
    private SensorManager mSensorManager;
    public float x;
    /** Called when the activity is first created. */
    public MyCompass(Context context) {
        mRegisteredSensor = false;
        //取得SensorManager实例
        mSensorManager = (SensorManager)context.getSystemService(Context.SENSOR_SERVICE);
        List<Sensor> sensors = mSensorManager.getSensorList(Sensor.TYPE_ORIENTATION);
        Sensor sensor = sensors.get(0);
        mSensorManager.registerListener(this, sensor, SensorManager.SENSOR_DELAY_FASTEST);
    }



    @Override
    protected void onPause()
    {
        if (mRegisteredSensor)
        {
            //如果调用了registerListener
            //这里我们需要unregisterListener来卸载/取消注册
            mSensorManager.unregisterListener(this);
            mRegisteredSensor = false;
        }
        super.onPause();
    }
    //当进准度发生改变时
    //sensor->传感器
    //accuracy->精准度
    @Override
    public void onAccuracyChanged(Sensor sensor, int accuracy)
    {

    }
    // 当传感器在被改变时触发
    @Override
    public void onSensorChanged(SensorEvent event)
    {
        // 接受方向感应器的类型
        if (event.sensor.getType() == Sensor.TYPE_ORIENTATION)
        {
            // 这里我们可以得到数据，然后根据需要来处理
            x = event.values[SensorManager.DATA_X];

            //_compassView.setDegree(x);

        }
    }
}