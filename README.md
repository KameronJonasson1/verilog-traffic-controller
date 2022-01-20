# Verilog Traffic Controller with Left Turn and Walk Light for Intel Cyclone IV E FPGA
Enclosed is a Verilog design and testbench for a traffic controller modelled after a real-world intersection. 
Based on the intersection of College Drive and Cumberland Avenue North, this traffic controller has a left-turn
light for southbound traffic attempting to go eastbound and four walk lights that rotate through three settings 
upon human input.  
  
[College Drive and Cumberland Avenue North Google Maps Pin](https://www.google.com/maps/@52.1287683,-106.6346211,3a,60y,311.1h,83.85t/data=!3m6!1e1!3m4!1ssQQjZKmkUEVrFCazm7EYIA!2e0!7i13312!8i6656)

## Design Overview
This Verilog design models a finite state machine with 13 states, 6 of which are default stages that control the simple
Red-Amber-Green functionality of a basic traffic controller. 6 states are dedicated to walk light functionality,
and there is one state to control the left turn light. Every state has a timer value which defines how long the state
will be held for in seconds.

## State Descriptions
### State Diagram
![IMG-0014](https://user-images.githubusercontent.com/93303200/150379761-3806a378-79ef-4db8-9990-33b323bf63b4.JPG)

### Default States
There are 6 default states [1,2,3,4,5,6] which control the simple Red-Amber-Green functionality of a basic traffic controller.
Without any human or sensor input, the controller will remain in these 6 states indefinitely. There are four 
traffic lights that are controlled in these states. The functional operation is defined by two sets of identical
operation directed at different lights. In these states, all walk lights hold the don't walk light on. This operation 
is defined by the following:

  - 1: Northbound and Southbound lights are green, Eastbound and Westbound lights are red - 60 Seconds
  - 2: Northbound and Southbound lights are amber, Eastbound and Westbound lights are red - 6 Seconds
  - 3: All lights are red - 2 Seconds
  - 4: Eastbound and Westbound lights are green, Northbound and Southbound lights are red - 60 Seconds
  - 5: Eastbound and Westbound lights are amber, Northbound and Southbound lights are red - 6 Seconds
  - 6: All lights are red - 2 Seconds

### Left Turn State
There is one left turn state [4a] in the intersection, and it controls southbound traffic attempting to go east. When the 
controller is in this state, it will light the southbound light with a left turn signal, and keep all other lights red.
This state is held for 20 seconds.

### Walk Light States
The meaningful walk light operation is controlled by 6 states [1w,1fd,1d,4w,4fd,4d] (w = walk, fd = flashing don't, d = don't)
In these six states the walk lights will move through three distinct visuals. These visuals describe the allowed pedestrian 
behavior in the following manner:

  - 1w: Eastbound and Westbound walk lights read "Walk", traffic lights have state 1 operation - 10 Seconds
  - 1fd: Eastbound and Westbound walk lights flash "Don't Walk", traffic lights have state 1 operation - 20 Seconds
  - 1d: Eastbound and Westbound walk lights read "Don't Walk", traffic lights have state 1 operation - 30 Seconds
  - 4w: Northbound and Southbound walk lights read "Walk", traffic lights have state 4 operation - 10 Seconds
  - 4fd: Northbound and Southbound walk lights flash "Don't Walk", traffic lights have state 4 operation - 20 Seconds
  - 4d: Northbound and Southbound walk lights read "Don't Walk", traffic lights have state 4 operation - 30 Seconds

## Inputs
### Left Turn Input
The traffic controller enters the left turn state if the one bit leftturn_request signal is active when leaving state 3. 
In a real-world implementation, I would use an inductive sensor to control the leftturn_request signal. In this implementation, 
I connected the leftturn_request signal to a key on the Cyclone IV E FPGA development board.

### Walk Request Input
Unlike the left turn input, a human request for a walk light comes from a single button press instead of a continuously held 
sensor value. To implement this functionality, I used a flip-flop to translate the single button press to a continuous 
signal that will trigger a walk light if active at the end of state 6, or state 3. In a real-world implementation, I would use 
a mechanical button in a hardened aluminum casing to allow humans to send input to the controller. In this implementation, I used 
a key on the Cyclone IV E FPGA development board.

## Outputs
All the meaningful outputs of the traffic light controller are sent to the 7-segment hexadecimal displays on the Cyclone IV E FPGA 
development board. The description of these outputs are placed below.
![IMG_0010 2](https://user-images.githubusercontent.com/93303200/147776932-29d03b25-7fa7-467c-9dff-d21ff3d15d3d.jpg)

### Traffic Light Output
The traffic light outputs are sent to hex displays 0, 2, 4, and 6. A green light is displayed by lighting the bottom horizontal segment, 
an amber light is displayed by lighting the middle horizontal segment, and a red light is displayed by lighting the top horizontal segment.
![IMG_0011](https://user-images.githubusercontent.com/93303200/147776943-aff28e8d-343a-4502-bb86-419559652ad9.jpg)

### Walk Light Output
The walk light outputs are sent to hex displays 1, 3, 5, and 7. A walk light is displayed by lighting the top-left vertical segment, a don't
walk light is displayed by lighting the segments that make a "d", and a flashing don't is displayed by flashing the don't light.
![IMG_0012](https://user-images.githubusercontent.com/93303200/147776952-a883fc3a-8b07-46f4-ad45-e6ff867bfa81.jpg)

### Left Turn Output
The left turn light is sent to the hex display that is associated with the southbound hex light (hex 2). A left turn light is displayed by 
lighting the two rightmost vertical segments and the middle horizontal segment.
![IMG_0013](https://user-images.githubusercontent.com/93303200/147776959-56979645-c782-4327-b2a3-dd5cb9f30bd7.jpg)

