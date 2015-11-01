package com.cogent.QQ;

import android.graphics.PointF;
import android.util.Log;

import java.util.Random;
import java.lang.Math;
/**
 * Created by Lyy on 2015/10/15.
 */
public class ParticleFilter {

    class PFPoint{
        private float x,y;
        private float P;
        public PFPoint(){
            x  = y = 0.0f;
            P = 0.0f;
        }
        public PFPoint(PFPoint p){
            x = p.x;
            y = p.y;
            P = p.P;
        }
        public PFPoint(PointF p) {
            x = p.x;
            y = p.y;
            P = 1.0f;
        }
        public void set(float nx, float ny, float np) {
            x = nx;
            y = ny;
            P = np;
        }
        public void setPosition(float nx, float ny){
            x = nx;
            y = ny;
        }
        public void setP(float np){
            P = np;
        }
        public void addP(float dx, float dy){
            x += dx;
            y += dy;
        }
    }
    private Random random;
    private PFPoint P[];
    private float mu = 0;
    private boolean First;
    private float sigma  = 1;
    private float MapScale = 60;
    private final float T = 1/ (float)(sigma * Math.sqrt(2 * Math.PI));
    private float scale = 1;
    public ParticleFilter(PointF newPoint, float mapscale){
        random = new Random();
        P = new PFPoint[100];
        scale = mapscale;
        First = false;
        int i;
        // Particles initializing
        P[0] = new PFPoint(newPoint);
        for (i = 1; i < 100; i++) {
            P[i] = new PFPoint();
            P[i].set(newPoint.x + (random.nextFloat() - 0.5f) * 100 * mapscale, newPoint.y + (random.nextFloat() - 0.5f) * 100 * mapscale, random.nextFloat());
        }
    }
    public void setMu(float nmu){
        mu = nmu;
    }
    public void setSigma(float nsigma){
        sigma = nsigma;
    }
    private float GaussDistribution(float x){
        return  T * (float)Math.exp( -( Math.pow(x-mu,2) /(2*Math.pow(sigma, 2))));
    }
    private void quickSort(PFPoint a[], int head, int end){
        if (head >= end) return;
        int i = head, j = end;
        PFPoint  key = a[head];
        Log.e("Particle Filter", "QS 0");
        while (i != j){
            while (a[i].P <= key.P && i!=j){
                ++i;
            }
            a[j] = a[i];
            while (a[j].P >= key.P && i!=j){
                --j;
            }
            a[i] = a[j];
            //Log.e("Particle Filter", "QS:" + i + ", " + j);
        }

        a[i] = key;
        quickSort(a, head, i-1);
        quickSort(a, i+1, end);
    }

    private PointF getCenter(PFPoint[] Ps){
        float tx=0,ty=0;
        for(PFPoint each : Ps){
            tx += each.x * each.P;
            ty += each.y * each.P;
        }
        tx /= 10;
        ty /= 10;
        Log.e("PFNext Out", String.format("%f,",tx) + String.format("%f",ty));
        return new PointF(tx, ty);
    }

    public boolean Initialized(){
        return First;
    }
    public void Init(PointF newPoint, float mapscale){
        First = false;
        scale = mapscale;
        int i;
        // Particles initializing
        P[0] = new PFPoint(newPoint);
        for (i = 1; i < 100; i++) {
            P[i] = new PFPoint();
            P[i].set(newPoint.x + (random.nextFloat() - 0.5f) * 100 * mapscale, newPoint.y + (random.nextFloat() - 0.5f) * 100 * mapscale, random.nextFloat());
        }

    }
    public PointF getNext(float dx,float dy){
        if (!First)
            First = true;
        Log.e("PFNext In", String.format("%f,",dx) + String.format("%f",dy));
        float deltaX, deltaY;
        PFPoint tmp[] = new PFPoint[10];
        int i,j;
        float g;
        deltaY = dx * MapScale;
        deltaX = dy * MapScale;
        Log.e("Particle Filter", "0");
        quickSort(P,0,99);
        g = 0;
        Log.e("Particle Filter","1");
        for (j = 0; j < 10; j++){
            Log.e("Gauss", String.format("%f",GaussDistribution((float)(mu - (j - 4.5)* sigma))));
            g += GaussDistribution((float)(mu - (j - 4.5)* sigma ));
        }
        Log.e("Point",""+g);
        for (i = 0; i < 10; i++) {
            tmp[i] = P[i];
            for (j = 0; j < 10; j++) {
                P[j * 10 + i].addP(deltaX + (MapScale * scale * GaussDistribution((float) (mu + ((j - 4.5) * sigma)))) / g, deltaY + (MapScale * scale * GaussDistribution((float) (mu + ((j - 4.5) * sigma)))) / g);
                P[j * 10 + i].setP(GaussDistribution((float) (mu + ((j - 4.5) * sigma))) / g);
                Log.e("Point", P[j*10+i].x+","+P[j*10+i].y+","+P[j*10+i].P);
            }
        }
        Log.e("Particle Filter","3");

        return getCenter(P);
    }

}
