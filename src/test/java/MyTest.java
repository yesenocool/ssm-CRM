import com.zxj.utils.DateTimeUtil;
import com.zxj.utils.MD5Util;
import org.junit.Test;

import java.util.HashMap;

public class MyTest {
    @Test
    public void test01(){
        String time1 = "2022-01-21 10:10:10";
        String sysTime = DateTimeUtil.getSysTime();
        int i = time1.compareTo(sysTime);
        System.out.println(i);
    }

    @Test
    public void test02(){
        String pwd="1234";
        String md5 = MD5Util.getMD5(pwd);
        System.out.println(md5);

    }

    @Test
    public int[] twoSum(int[] nums, int target) {
        HashMap<Integer,Integer> map  = new HashMap<>();
        for(int i =0;i<nums.length;i++){
            int val = nums[i];
            int result= target-val;
            if(map.containsKey(result)){
                return new int[]{i,map.get(result)};
            }
                map.put(val,i);
            }
        return null;
        }

        @Test
        public ListNode addTwoNumbers(ListNode l1, ListNode l2) {
            while(true){
                if(l1.next.val>=0){

                }
            }


        }
        public class ListNode {
             int val;
             ListNode next;
             ListNode() {}
             ListNode(int val) { this.val = val; }
             ListNode(int val, ListNode next) { this.val = val; this.next = next; }
        }

    }






