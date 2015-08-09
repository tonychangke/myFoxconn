package com.cogent.QQ;

import com.android.volley.VolleyError;
import com.cogent.util.ContactUtils;
import java.io.ByteArrayOutputStream;
import java.util.HashMap;
import java.util.Map;

import net.yoojia.imagemap.ImageMap;
import net.yoojia.imagemap.core.Bubble;
import net.yoojia.imagemap.core.CircleShape;
import net.yoojia.imagemap.core.Shape;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.graphics.drawable.BitmapDrawable;
import android.text.Editable;
import android.text.TextWatcher;
import android.os.Bundle;
import android.util.Log;

import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewDebug;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.Toast;
import android.graphics.drawable.Drawable;


import com.cogent.Communications.Communications;
import com.cogent.DataBase.BLConstants;
import com.cogent.DataBase.DBHelper;
import com.cogent.ViewMenu.ViewTabber;

import com.cogent.Communications.BLNotifier;
import com.cogent.Communications.BLIObserver;
import com.cogent.util.HttpUtil;
import com.cogent.util.TaskUtil;
import com.hp.hpl.sparta.xpath.Step;

import javax.sql.CommonDataSource;

public class LocationActivity extends BaseActivity implements BLIObserver {
    private static final String DEBUG_TAG = "LocationActivity";
    protected static BeaconService mBoundService = null;
    private ImageMap map;
    private Boolean isOnline = true;
	ViewTabber tabbar;

    private StepCalculater StepCal;
	private ImageView ivDeleteText;
	private EditText etSearch;
	private Button btn_search;
    private DBHelper dbHelper;

    float scalesize = 1;
	private int current_map = -1;
	private int mapid = 0;
    private int cur_x = 285; // What is the scale? 1 mean what? not pixel. 285 correspond to the corridor
    private int cur_y = 300;
    private String cur_rss="0,0,0";


	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
        Log.d(DEBUG_TAG, "onCreate");
        mBoundService = WelcomeActivity.getBoundService();
        StepCal = new StepCalculater(this);
        StepCal.stopstep();
        WelcomeActivity.registerObserver(this);
		setContentView(R.layout.tab_view);
		ContactUtils.init(this);
		tabbar = new ViewTabber(this);
		dbHelper = new DBHelper(this);

        map = (ImageMap) findViewById(R.id.imagemap);
        /* 这是测试本地服务器post和get请求的代码
        Map tmp_Map = new HashMap<String, String >() ;
        tmp_Map.put("id","This is a test");
        mComm.doVolleyPost(BLConstants.API_TEST,tmp_Map,"mTag");
        mComm.doVolleyGet(BLConstants.API_TEST,"myTag");
        */
		initView();
        /*
        Map<String, String> query_pos_map = new HashMap<String, String>();
        query_pos_map.put("rss", "0,0,0");
        mComm.doVolleyPost(BLConstants.API_TEST5,query_pos_map, Communications.TAG_QUERY_POSITION);
        */
	}

    @Override
    public void onResume() {
        super.onResume();
        Log.d(DEBUG_TAG, "onResume");
        if (mBoundService != null)
            mBoundService.startScan(cur_rss);
    }
    
    @Override
    public void onPause() {
        super.onPause();
        Log.d(DEBUG_TAG, "onPause");
        if (mBoundService != null)
            mBoundService.stopScan();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        Log.d(DEBUG_TAG, "onDestroy");
        WelcomeActivity.unregisterObserver(this);
    }

	public void initView() {
		ivDeleteText = (ImageView) findViewById(R.id.ivDeleteText);
        //btn_search = (ImageView) findViewById(R.id.btnSearch);
		btn_search = (Button) findViewById(R.id.btnSearch);
        etSearch = (EditText) findViewById(R.id.etSearch);

        ivDeleteText.setOnClickListener(new OnClickListener() {
			
			public void onClick(View v) {
				etSearch.setText("");
			}
		});

        etSearch.addTextChangedListener(new TextWatcher() {
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                // TODO Auto-generated method stub
            }

            public void beforeTextChanged(CharSequence s, int start, int count,
                                          int after) {
                // TODO Auto-generated method stub
            }

            public void afterTextChanged(Editable s) {
                if (s.length() == 0) {
                    ivDeleteText.setVisibility(View.GONE);
                } else {
                    ivDeleteText.setVisibility(View.VISIBLE);
                }
            }
        });

        // set the offline map
        Drawable d = getResources().getDrawable(R.drawable.floor4_0);

        Bitmap OfflineMap = ((BitmapDrawable)d).getBitmap();
        scalesize = TaskUtil.calcScaleSize(OfflineMap);
        Bitmap resizedBmp = TaskUtil.reSizeBitmap(OfflineMap, scalesize);
        final ByteArrayOutputStream os = new ByteArrayOutputStream();
        resizedBmp.compress(Bitmap.CompressFormat.JPEG, 100, os);
        dbHelper.insertOrUpdate(mapid, mapid, "", scalesize, os.toByteArray());
        map.setMapBitmap(resizedBmp);
        StepCal.startstep(cur_x,cur_y);

        Log.e("Step X Y", StepCal.get_step_offset_X() + "," + StepCal.get_step_offset_Y());
        parseLocation(mapid + "," + StepCal.get_step_offset_X() + "," + StepCal.get_step_offset_Y(), 2);

        btn_search.setOnClickListener(new OnClickListener() {

            public void onClick(View v) {
                mComm.doVolleyPost(BLConstants.API_TEST_CONNECT, null, Communications.TAG_TEST_CONNECT);
                Log.e("Step Counter", StepCal.getsteps() + "");

//                if (isOnline) {
//                    System.out.println(btn_search.getText().toString().trim());
//                    Map<String, String> query_pos_map = new HashMap<String, String>();
//                    //query_pos_map.put(BLConstants.ARG_USER_ID, etSearch.getText().toString().trim());
//                    query_pos_map.put("rss", etSearch.getText().toString().trim());
//                    mComm.doVolleyPost(BLConstants.API_TEST5, query_pos_map, Communications.TAG_QUERY_POSITION);
//                } else {
                    cur_x = cur_x;
                    cur_y = cur_y +10;
                    //Log.e("Step X Y", StepCal.get_step_offset_X() + "," + StepCal.get_step_offset_Y());
                    Log.e("Current xy", Integer.toString(cur_x)+","+Integer.toString(cur_y));
                    //parseLocation(mapid + "," + StepCal.get_step_offset_X() + "," + StepCal.get_step_offset_Y(), 2);
                parseLocation(mapid + "," + cur_x + "," + cur_y, 2);


//                }
            }
        });
	}
	
	public void goBack(View view) {
		//onBackPressed();
		//tabbar.switchViewTab(0);
		tabbar.viewContainer.flipToView(0);
		tabbar.setViewTab(0);
	}
    
    class bledevice {
        String devicemac = "";
        int rec_rssi = 0;
    }
    @Override
    public void onFail(String tag, String response){
        Log.e("EEEEEEEEE", "abcd");
        //parseLocation("0,250,250", 2);
    }
    @Override
    public void onErrorResponse(String tag, VolleyError volleyError) {
        //Log.e("LLLLLLLLL", volleyError.getMessage(), volleyError);
        if (tag.equals(Communications.TAG_TEST_CONNECT)){
            Log.e("Connect Failed","==============");
            if(isOnline)
                Log.e("Start Step Calculator","================");
            StepCal.startstep(cur_x,cur_y);
            isOnline = false;

        }

    }
    @Override
    public void onSuccess(String tag, String response){
        if (tag.equals(Communications.TAG_QUERY_MAP)) {
            String mapurl = BLConstants.API_TEST4 +response;//HttpUtil.parseJson(response, BLConstants.ARG_MAP_URL);
            downloadMap(mapurl);
            //showPostion(100,100);
        }
        if (tag.equals(Communications.TAG_TEST_CONNECT)){
            Log.e("Connect Success","=============");
            if(!isOnline)
                Log.e("Stop Step Calculator", "==================");
            StepCal.stopstep();
            isOnline = true;
        }
        if (tag.equals(Communications.TAG_QUERY_POSITION)) {
            if(!response.isEmpty()){
                Log.e("WWWWWWWWW","Location_onSuccess_QueryPosition_parseLocation");
                cur_x = Integer.parseInt(response.split(",")[1]);
                cur_y = Integer.parseInt(response.split(",")[2]);
                //parseLocation(response, BLNotifier.TYPE_MANUAL_UPDATE_LOCATION); //comment this so we can observe offline case
            }
            /*
            if (response.isEmpty()) {
                tmpmap.put("mapid", response.split(",")[0]);
                mComm.doVolleyPost(BLConstants.API_TEST5, tmpmap, Communications.TAG_QUERY_MAP);
                Log.d(DEBUG_TAG, tag + ": empty response");
            }
            else {
                Log.e("WWWWWWWWW","Location_onSuccess_QueryPosition_parseLocation");
                parseLocation(response, BLNotifier.TYPE_MANUAL_UPDATE_LOCATION);
            }*/
        }
    }
    @Override
    public void refreshUI(){
        map.clearShapes();
    }
    @Override
    public void onImageResponse(String tag, Bitmap response) {
        /*/test
        Log.d(DEBUG_TAG, "Resize the map.");
        scalesize = TaskUtil.calcScaleSize(response);
        Bitmap resizedBmp = TaskUtil.reSizeBitmap(response, scalesize);
        final ByteArrayOutputStream os = new ByteArrayOutputStream();
        resizedBmp.compress(Bitmap.CompressFormat.PNG, 100, os);
        dbHelper.insertOrUpdate(mapid, mapid, "",scalesize, os.toByteArray());

        map.setMapBitmap(resizedBmp);
        //test end */

        if (tag.equals(Communications.TAG_DOWNLOAD_MAP)) {
            if (response == null || response.getHeight() == 0 || response.getWidth() == 0)
                Log.d(DEBUG_TAG, "null bitmap");
            else
            {
                Log.d(DEBUG_TAG, "Resize the map.");
                scalesize = TaskUtil.calcScaleSize(response);
                Bitmap resizedBmp = TaskUtil.reSizeBitmap(response, scalesize);
                final ByteArrayOutputStream os = new ByteArrayOutputStream();
                resizedBmp.compress(Bitmap.CompressFormat.PNG, 100, os);
                dbHelper.insertOrUpdate(mapid, mapid, "",scalesize, os.toByteArray());

                map.setMapBitmap(resizedBmp);
            }
        }

    }
    
    public void getMapInfo(final int mapid)
    {
        Log.d(DEBUG_TAG, "Query map by map ID: " + mapid);
        Map<String, String> query_map = new HashMap<String, String>();
        query_map.put(BLConstants.ARG_MAP_ID, Integer.toString(mapid));
        //query_map.put("mapid", mapid+"");
        mComm.doVolleyPost(BLConstants.API_QUERY_MAP_BY_MAPID, query_map, Communications.TAG_QUERY_MAP);
    }
    
    public void downloadMap(final String mapurl)
    {
        Log.d(DEBUG_TAG, "Download map with url: ." + mapurl);
        mComm.doVolleyImageRequest(mapurl, Communications.TAG_DOWNLOAD_MAP);
    }
    
    public boolean showPostion(double x, double y){ //该方法可以实现一个圆点，用于和bubble进行绑定，并且最终显示在地图上
        Log.d("Show position",Double.toString(x)+","+Double.toString(x));
        CircleShape black = new CircleShape("NO", Color.BLACK); //Color.BLUE，圆点的颜色
        black.setValues(String.format("%.5f,%.5f,15",x*scalesize,y*scalesize)); //设置圆点的位置和大小
        map.addShapeAndRefToBubble(black); //加到地图上
        return true;
    }

    private void parseLocation(String args, final int type) {
            Log.d(DEBUG_TAG, "parseLocation type: " + type);
            int positionX, positionY;
            String[] tmp = args.split(",");
            positionX =Integer.parseInt(tmp[1]);//HttpUtil.parseJsonsdouble(args,BLConstants.ARG_POSITION,BLConstants.ARG_POSITION_X);
            positionY = Integer.parseInt(tmp[2]);//HttpUtil.parseJsonsdouble(args,BLConstants.ARG_POSITION,BLConstants.ARG_POSITION_Y);
            mapid = Integer.parseInt(tmp[0]);//HttpUtil.parseJsonsdouble(args,BLConstants.ARG_POSITION,BLConstants.ARG_MAP_ID);

            if (type == BLNotifier.TYPE_AUTO_UPDATE_LOCATION) {
                String messages = HttpUtil.parseJson(args, BLConstants.ARG_POSITION_MSG);
                if (!messages.isEmpty())
                    showNotification(messages);
            }
            Log.e("Map id =",String.valueOf(mapid));
            Log.e("Cur_Map id =",String.valueOf(current_map));
            if (mapid != current_map )//&& mapid != 0)
            {
                current_map = mapid;
                Bitmap findmap = dbHelper.queryMap(mapid);
                if(findmap == null)
                {
                    Log.e("Geting Map Info",mapid+"");
                    getMapInfo(mapid);
                }
                else
                {
                    Log.e(DEBUG_TAG, "Find map in local database.");
                    scalesize = dbHelper.queryScalesize(mapid);
                    map.setMapBitmap(findmap);
                }
            }
            map.clearShapes();

            View bubble = getLayoutInflater().inflate(R.layout.popup, null);
            map.setBubbleView(bubble,new Bubble.RenderDelegate() {
                @Override
                public void onDisplay(Shape shape, View bubbleView) {
                    ImageView logo = (ImageView) bubbleView.findViewById(R.id.logo); //通过bubbleView得到相应的控件
                    if (type == BLNotifier.TYPE_AUTO_UPDATE_LOCATION)
                        logo.setImageResource(R.drawable.location_icon_purple);
                    else if (type == BLNotifier.TYPE_MANUAL_UPDATE_LOCATION)
                        logo.setImageResource(R.drawable.location_icon_yellow);
                }
            });
            Log.e("Position Showing", positionX + " , " + positionY);
            showPostion(positionX, positionY);
        }
    
    public void onBLUpdate(int notificationType, String args) {
        /*switch (notificationType) {
            case BLNotifier.TYPE_BLE_NOT_SUPPORT:
                showNotification(R.string.ble_not_supported);
                break;
            case BLNotifier.TYPE_BLE_NOT_ENABLED:
                showNotification(R.string.error_bluetooth_not_supported);
                break;
            case BLNotifier.TYPE_AUTO_UPDATE_LOCATION:
                if (!args.isEmpty())
                    parseLocation(args, notificationType);
                break;
            default:
                break;
        }*/
    }
}
