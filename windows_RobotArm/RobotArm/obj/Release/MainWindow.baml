   M S B A M L   `   `   `  ���� C  ?RobotArm, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null#clr-namespace:RobotArmRobotArm  /clr-namespace:RobotArm.servoRobotArm.servo      RobotArm.MainWindow   \ XPresentationFramework, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35R NWindowsBase, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35W SPresentationCore, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35D 9http://schemas.microsoft.com/winfx/2006/xaml/presentation    R NSystem.Xaml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089:x,http://schemas.microsoft.com/winfx/2006/xaml     @d2http://schemas.microsoft.com/expression/blend/2008     Jmc;http://schemas.openxmlformats.org/markup-compatibility/2006     (localclr-namespace:RobotArm     .servoclr-namespace:RobotArm.servo     -     � Title$  开源机械臂V1.1测试��$	��650��$
��1180��.���  � ColumnDefinitions �� $��* ��� $
��1.8* �.+��� $��1q�
����ح�$��0��$��5q�._��� -    ��Name$ 
servosView��$
��Left=�$	��600��$	��Top=�$	��400��.@��� $��	PWM舵机��.���� .+�   RobotArm.servo.ServoView  -     Name$ servo1��   ServoId$ 1��$	��106��$��78�� �� Left$ 25��
 �� Top$ 35��   MinAngle$	 500H�   MaxAngle$
 2500H�	   CurAngle$
	 1500H�  -   $ servo2��$ 2��$	��106��$��78��$ 78��$	 125��$	 500H�$
 2500H�$
	 1500H�  -   $ servo3��$ 3��$	��106��$��78��$	 130��$	 215��$	 500H�$
 2500H�$
	 1500H�  -   $ servo4��$ 4��$	��106��$��78��$	 178��$	 305��$	 500H�$
 2500H�$
	 1500H�  -   $ servo5��$ 5��$	��106��$��78��$	 274��$	 395��$	 500H�$
 2500H�$
	 1500H�  -   $ servo6��$ 6��$	��106��$��78��$	 222��$	 485��$	 500H�$
 2500H�$
	 1500H��� $��总线舵机��.���� .+�  -	   $ 
bus_servo1��$ 1��$	��106��$��78��$ 25��$ 35��$ 0H�$
 1000H�$		 500H�  -
   $ 
bus_servo2��$ 2��$	��106��$��78��$ 78��$	 125��$ 0H�$
 1000H�$		 500H�  -   $ 
bus_servo3��$ 3��$	��106��$��78��$	 130��$	 215��$ 0H�$
 1000H�$		 500H�  -   $ 
bus_servo4��$ 4��$	��106��$��78��$	 178��$	 305��$ 0H�$
 1000H�$		 500H�  -   $ 
bus_servo5��$ 5��$	��106��$��78��$	 274��$	 395��$ 0H�$
 1000H�$		 500H�  -   $ 
bus_servo6��$ 6��$	��106��$��78��$	 222��$	 485��$ 0H�$
 1000H�$		 500H�� $��1��
 � RowDefinitions
 �� $��5* ��� $
��1.5* ��� $
��0.6* ��� $��4* � �� $��* ��� $
��0.8* ��� $��* ��� $
��1.2* �.+�&   System.Windows.Controls.DataGrid  -     Name$ 
actionList��$��4��$��0��$��5q�   AutoGenerateColumns .     GridLinesVisibility$	 All=�   CanUserAddRows .     SelectionMode$ Single=�   CanUserResizeColumns .     CanUserResizeRows .     Columns 4  .System.Windows.Controls.DataGridTemplateColumn  ,  &System.Windows.Controls.DataGridColumn   Width5  /System.Windows.Controls.DataGridLengthConverter$ 50    
IsReadOnly .    CellTemplate �� .R��� $
��None=����� *	IndexPath+ �� UpdateSourceTrigger$ PropertyChanged=�0  *System.Windows.Controls.DataGridTextColumn     Header$ 编号��$ 50  . 1  +System.Windows.Controls.DataGridBoundColumn   Binding ��  �� Path$ itemID�  $ 
时间(ms)��$ 90  �� $ 	servoTime� �� Mode$ TwoWay=�$ PropertyChanged=�  $
 ID:1��$ 90  �� $ servoAngles[0]�$ TwoWay=�$ PropertyChanged=�  $
 ID:2��$ 90  �� $ servoAngles[1]�$ TwoWay=�$ PropertyChanged=�  $
 ID:3��$ 90  �� $ servoAngles[2]�$ TwoWay=�$ PropertyChanged=�  $
 ID:4��$ 90  �� $ servoAngles[3]�$ TwoWay=�$ PropertyChanged=�  $
 ID:5��$ 90  �� $ servoAngles[4]�$ TwoWay=�$ PropertyChanged=�  $
 ID:6��$ 90  �� $ servoAngles[5]�$ TwoWay=�$ PropertyChanged=��� $��1q�
����ح�$��4��$��1��$��5q�._���  �� Orientation$ 
Horizontal=�.+��� $��动作时间��$��20q��� -    ��Name$ 
actionTime��$
��1000��$��50��$��
0,20,30,20q��� -   $��添加动作��$��20,15,20,15q�$	��100���� -   $��删除动作��$��20,15,20,15q�$	��100���� -   $��更新动作��$��20,15,20,15q�$	��100���� -   $��插入动作��$��20,15,20,15q�$	��100���� -    ��Name$ filePath��$��5q�$��4��$��2���� $��1q�
����ح�$��0��$��3��$��5q�._��� .+��� $
��COM:��$ 10��$ 46���� -    ��Name$ 	SerialCom��$
��25px��$
��80px��$ 70��$ 40���� -   $ BaudTB��$��
波特率:��$ 10��$ 93���� -   $ BaudRate��$
��25px��$
��80px��$ 70��$ 93���� -    ��Name$ 
ConnectLed��$
��30px��$+��%/RobotArm;component/Resources/red.png��$ 10��$	 150���� -     ��Name$  OpenCloseBtn��$��打开串口��$
��30px��$
��80px��$ 70��$	 150���� $��1��$��3��.+��� $ 4��$	��120��$	��151���� -   ! ��Name$! 	loopCheck��$��循环��$
��Left=�$��	32,25,0,0q�$	��Top=�$��20��$��55���� -   $  	runOnline��$��在线运行��$ 28��$ 70��$	��108��$��40���� -   $��复位舵机��$ 20��$	 153��$	��113��$��45���� $��1q�
����ح�$��2��$��3��$��5q�._��� $ Vertical=�.+��� -   $��打开文件��$��25,10q�$��48���� -   $��保存文件��$��25,10q�$��48���� -    $��串联动作文件��$��25,10q�$��48���� $��1q�
����ح�$��3��$��3��$��5q�._��� .+��� $ 43��$
��Wrap=�$��
动作组:��$ 23���� -!   $ 	actionNum��$ 96��$ 14��$��93��$��30���� -"   $  downLoad��$��下载��$ 43��$ 64��$	��146��$��40���� -#   $  eraseAll��$��全部擦除��$ 43��$	 113��$	��146��$��36���� -$   $  	runAction��$��动作组运行��$ 43��$	 162��$��70��$��40���� -%   $  
stopAction��$��停止��$	 127��$	 162��$��60��$��40��