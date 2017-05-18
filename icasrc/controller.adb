with HWIF; use HWIF;
with HWIF_Types; use HWIF_Types;
with Ada.Real_Time; use Ada.Real_Time;

procedure Controller is
   procedure Delay_Traffic_Light (Light_Color : Integer; Dir1 : Direction; Dir2 : Direction; Start_Time : Time) is
      Release_Time : Time;
   begin
      if Light_Color = 1
      then
         if Emergency_Vehicle_Sensor(Dir1) = 1 or
           Emergency_Vehicle_Sensor(Dir2) = 1
         then
            while Emergency_Vehicle_Sensor(Dir1) = 0 and
              Emergency_Vehicle_Sensor(Dir2) = 0
            loop
               delay 0.5;
            end loop;

            Release_Time := Clock + Seconds(10);
         else
            Release_Time := Start_Time + Seconds(5);
         end if;
      elsif Light_Color = 2 or Light_Color = 6
      then
         Release_Time := Start_Time + Seconds(3);
      end if;

      delay until Release_Time;
   end Delay_Traffic_Light;

   task Button_Pressed;
   task body Button_Pressed is
   begin
      Task_Loop :
      loop
         if (Pedestrian_Button(North) = 1 and Pedestrian_Light(North) /= 1 and Pedestrian_Wait(North) /= 1) or
           (Pedestrian_Button(East) = 1 and Pedestrian_Light(East) /= 1 and Pedestrian_Wait(East) /= 1) or
           (Pedestrian_Button(South) = 1 and Pedestrian_Light(South) /= 1 and Pedestrian_Wait(South) /= 1) or
           (Pedestrian_Button(West) = 1 and Pedestrian_Light(West) /= 1 and Pedestrian_Wait(West) /= 1)
         then
            Pedestrian_Wait(North) := 1;
            Pedestrian_Wait(East) := 1;
            Pedestrian_Wait(South) := 1;
            Pedestrian_Wait(West) := 1;
         end if;
         delay 0.19;
      end loop Task_Loop;
   end Button_Pressed;

Release_Time : Time;
begin
   loop
      --north/south
      Traffic_Light(North) := 6;
      Traffic_Light(South) := 6;
      Delay_Traffic_Light(6, North, South, Clock);

      Traffic_Light(North) := 1;
      Traffic_Light(South) := 1;
      Delay_Traffic_Light(1, North, South, Clock);

      Traffic_Light(North) := 2;
      Traffic_Light(South) := 2;
      Delay_Traffic_Light(2, North, South, Clock);

      Traffic_Light(North) := 4;
      Traffic_Light(South) := 4;

      --east/west
      Traffic_Light(East) := 6;
      Traffic_Light(West) := 6;
      Delay_Traffic_Light(6, East, West, Clock);

      Traffic_Light(East) := 1;
      Traffic_Light(West) := 1;
      Delay_Traffic_Light(1, East, West, Clock);

      Traffic_Light(East) := 2;
      Traffic_Light(West) := 2;
      Delay_Traffic_Light(2, East, West, Clock);

      Traffic_Light(East) := 4;
      Traffic_Light(West) := 4;

      if Pedestrian_Wait(North) = 1 or
        Pedestrian_Wait(East) = 1 or
        Pedestrian_Wait(South) = 1 or
        Pedestrian_Wait(West) = 1
      then
         Release_Time := Clock + Seconds(6);
         Pedestrian_Light(North) := 1;
         Pedestrian_Light(East) := 1;
         Pedestrian_Light(South) := 1;
         Pedestrian_Light(West) := 1;

         Pedestrian_Wait(North) := 0;
         Pedestrian_Wait(East) := 0;
         Pedestrian_Wait(South) := 0;
         Pedestrian_Wait(West) := 0;
         delay until Release_Time;

         Pedestrian_Light(North) := 2;
         Pedestrian_Light(East) := 2;
         Pedestrian_Light(South) := 2;
         Pedestrian_Light(West) := 2;
      end if;
   end loop;
end Controller;
