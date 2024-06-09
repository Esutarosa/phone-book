# Phone Book on MIPS

This project represents a simple phonebook implemented in MIPS assembly language. It allows users to manage a list of contacts, including adding new entries, querying existing ones, and quitting the program.

## Project Structure

- **phonebook.asm**: This file contains the main code for the phonebook, including functions for adding, querying, and quitting the program.
- **README.md**: This markdown file provides an overview of the project, including usage instructions and examples of program operation.

## Usage Instructions

1. **Clone the Repository**: Clone or download the repository to your local machine.
2. **Open the Code**: Open the `phonebook.asm` file in a MIPS assembly language editor or development environment.
3. **Run the Program**: Use a MIPS emulator or simulator such as SPIM or MARS to run the program.

## Main Features

- **Adding Entries**: Users can add new contacts to the phonebook by providing their first name, last name, and phone number.
- **Querying Entries**: Users can search for existing contacts by their entry number and view their details.
- **Quitting the Program**: Users can exit the program when they are finished managing their phonebook.

## Notes
- The maximum number of entries in the phone book is limited to ten
- The program stores data in a list array, each entry takes 62 bytes
- The program is implemented in MIPS assembly language, and to run it you need an appropriate emulator or simulator

## Examples of Program Operation

### New Entry

```plaintext
Please enter first name:
John
Please enter last name:
Doe
Please enter the phone:
123456789
Thank you, the new entry is:
John Doe 123456789
```

## Commands to get started

### Get start
```sh-session
Please determine operation, entry (E), inquiry (I) or quit (Q):
```

| E                     | I                   | Q                   |
|-----------------------|---------------------|---------------------|
| To enter a new entry  | To request an entry | To exit the program |



### Entering a new entry (E)

```sh-session
Please enter first name:
[name]
Please enter last name:
[name]
Please enter the phone:
[phone]
Thank you, the new entry is:
[name] [name] [phone]
```

### Record request (I)

```sh-session
Enter the number of the entry you wish to retrieve:
3
The number is:
3. John Doe 123456789
```

### Shutdown (Q)

```sh-session
Bye!
```

## What if?

### If the entry does not exist

```sh-session
There is no such entry in the phonebook.
```

### If the user enters an incorrect character in the main menu

```sh-session
The character you have entered does not correspond to any operation.
```

### If the user tried to add more than 10 entries

```sh-session
There have already been 10 entries!
```

