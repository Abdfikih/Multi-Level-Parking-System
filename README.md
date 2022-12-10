# :car: Multi-Level Parking System/Program :car:
>This program is one of the requirements in fulfilling the task of Digital System Design for the Computer Engineering Department at the University of Indonesia.

## *BACKGROUND*
---
Currently, many urban areas face challenges with parking due to a growing population and an increasing number of vehicles. Traditional surface-level parking lots are often unable to keep up with the demand for parking, leading to traffic congestion, long search times for parking spots, and frustration for drivers. That's why we create multi-level parking systems.
Multi-level parking systems offer a solution to these challenges by providing additional parking capacity in a smaller footprint. These systems typically consist of several levels of parking stacked on top of each other, with ramps or elevators to access the different levels. This allows for more cars to be parked in a given area compared to a traditional surface-level parking lot.
In addition to increased parking capacity, multi-level parking systems can also provide additional safety features, such as security cameras and controlled access, that can help to prevent accidents and reduce the risk of theft and vandalism. They can also make it easier for drivers to find a parking spot, thanks to features like directional signs and automatic parking guidance systems. This can help to reduce traffic congestion and improve the overall parking experience.
Furthermore, a multi-level parking system can help to reduce the amount of land and resources required for parking, which can have a positive impact on the environment. This can be especially important in urban areas where space is limited and the demand for parking is high.
 
----
## *DESCRIPTIONS*
----
This project aims to develop a VHDL-based simulation of a multi-level parking system. The system will be able to simulate the behavior of a parking lot with multiple floors and different capacities for each floor. The main function of the multi-level parking system is to provide a convenient and organized way to park cars in a large parking lot with multiple floors.

The system has a feature where when a car enters the gate, a check will be made on the availability of parking spaces. If the parking space is full, the lights will turn on and if it is available, the lights will turn off. When the parking space is available, the input of the license plate number will be made. When the license plate number is entered, the license plate number will be converted into a 32-bit password where the encryption algorithm has been determined in the code. Both will be displayed on the seven-segment alternately, which is regulated by the multiplexer and entered into the record so that it will be recorded and stored. After the car has been successfully placed in the available parking space in multi level park, the time of entry will be stored and the time will continue to run until the car is ready to be taken. When the car is ready to be taken, the user will be asked to enter the license plate number and password of the car. Then, the duration of the parking time will stop and be multiplied by the unit parking fee. After that, the parking fee to be paid will be displayed, then payment is made automatically and the car successfully exits. The memory of the existing car will be erased and ready to be filled with cars that want to enter.

This program created by: 
*Grup A6 PSD 01*
1. Abdul Fikih Kurnia                    (2106731485)
2. Aqib Rahman Radhi                     (2106731226)
3. Bernanda Nautval Raihan Ihza Windarto (2106708463)
4. Rafie Amandio Fauzan                  (2106731232)

---
## *FEATURE*
---
### Encrypt Password
Encrypting a password with a 32-bit key means that the password is converted into a scrambled, unreadable form using a mathematical algorithm and a key that is 32 bits long. This makes it difficult for anyone who does not have the key to decipher the encrypted password and access the underlying information.
To encrypt a password with a 32-bit key, the encryption algorithm takes the password and the key as input, and applies a series of mathematical operations to the password to generate an encrypted version of the password. The key is used to control the encryption process and determine the specific details of how the password is scrambled.

### Overload Parking
Overloads in a multi-level parking lot refer to situations where the number of cars trying to park in the lot exceeds the available parking spots. This can happen when the parking lot is full, or when the demand for parking is higher than the capacity of the lot. Overloads in a parking system can be indicated by the use of lights. For example, the lights on the entrance to the parking system may turn red, indicating that the system is full and no more cars can be accommodated.

### Automatic Parking Assigment
Automatic parking assignment refers to the use of technology to automatically assign parking spots to cars in a parking system. Can use algorithms or rules to determine which parking spots are available and assign them to incoming cars. The main advantage of automatic parking assignment is that it can help to optimize the use of the parking system and prevent congestion. By automatically assigning parking spots to cars, it can ensure that the available parking spots are used efficiently and that cars are parked in the most convenient and efficient locations. This can reduce the time and effort required to find a parking spot, and can help to prevent traffic jams and delays.

### Calculate The Parking Fee According To The Duration
Calculating the fee for parking refers to the process of determining the amount of money that a driver should pay to park their car in a parking system. The fee can be based on various factors, such as the duration of the parking. To calculate the fee for parking, the parking system may use inputs, such as the time that the car entered the parking system and the time that the car left the parking system. Once the inputs have been collected and processed, the system can use the rules or algorithms to calculate the fee for parking. The result of the calculation can be displayed to the driver and it can be automatically applied to the payment process.

---
## *Circuit Diagram Schematic*
---

## *Application Program Reports*
---

## *Functions*
---
### *Gate*
The system has a feature where when a car enters the gate, a check will be made on the availability of parking spaces. If the parking space is full, the lights will turn on and if it is available, the lights will turn off. When the parking space is available, the input of the license plate number will be made. When the license plate number is entered, the license plate number will be converted into a 32-bit password where the encryption algorithm has been determined in the code.

### *Lift Controller*
After passing through the gate, the car will enter the lift which shows the available parking space. The parking space will be filled starting from the lowest floor to the highest floor. In this program, there are 4 floors and each floor has 4 parking space positions.

### *Payment Control*
In the payment controller, there will be calculations on the parking fees for each car based on the duration of the parking time. The time will be multiplied by the unit parking fee that has been determined. The time taken is the time when storing and releasing the car recorded on the gate that is adjusted to the simulation time of the program so that each car will have different time variations and looks more realistic.

### *Room Memory*
Room memory is a storage type record in VHDL. Room memory will store the license plate number, password, parking status, time of entry and exit, and parking fee. The stored data will be the foundation in the running of this circuit program. After the car exits, the stored data for the car will be erased.

### *Multilevel*
Multilevel is used as a storage for several packages that will be used in the program so that the program can be run as it should. Here there is also an algorithm used to do hashing password of 32 bits. In this multilevel there are also various states that will be used.

### *Mux 4 to 1*
Mux 4 to 1 will function as a selector for which output will be displayed on the seven-segment, whether to display the output of the 16-bit input/out license plate number and the 32-bit input/out password which means that 8 seven-segment are needed

### *Seven Segment*
The seven segment will display the output of the 16-bit input/out license plate number and the 32-bit input/out password. Here the license plate that is 16 bits will be ampersanded so that it can become 32 bits and there will be 8 seven segments which are hexadecimal so that 1 seven segment processes 4 bits.

---
