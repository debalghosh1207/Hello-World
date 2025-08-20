# Project Structure and Functionality

## Current Project Structure
```
Hello-World/
├── CMakeLists.txt
├── LICENSE
├── main.cpp
├── README.md
├── say_hello/
│   ├── say_hello.cpp
│   └── say_hello.hpp
├── say_hi/
│   ├── say_hi.cpp
│   └── say_hi.hpp
└── say_hello_world/          # NEW in v1.2.0
    ├── say_hello_world.cpp
    └── say_hello_world.hpp
```

## Application Functionality

When you run the `helloworld` executable, it will output:
```
Hello
Hi 
Hello World
```

### Module Breakdown:
1. **say_hello module**: Outputs "Hello"
2. **say_hi module**: Outputs "Hi"  
3. **say_hello_world module**: Outputs "Hello World" (NEW in v1.2.0)

## Build Process
The CMakeLists.txt now includes all three modules:
- Source files: `say_hi.cpp`, `say_hello.cpp`, `say_hello_world.cpp`, `main.cpp`
- Header files: `say_hi.hpp`, `say_hello.hpp`, `say_hello_world.hpp`
- Include directories: `./say_hello`, `./say_hi`, `./say_hello_world`

## Recipe Upgrade Path

### Version History:
- **v1.0.0**: Basic hello/hi functionality
  - Recipe: `helloworld_1.0.0.bb`
  - SRCREV: `73f108705eff67567c85f3d9db535d1f7b35cf56`

- **v1.1.0**: Added documentation and versioning
  - Recipe: `helloworld_1.1.0.bb` 
  - SRCREV: `b91a1e4d40a05f40272bbf5ba58d67523c664c05`

- **v1.2.0**: Added say_hello_world module
  - Recipe: `helloworld_1.2.0.bb`
  - SRCREV: `381205a5486526f906c9e3b287f0b59cd5d5af85`

### Using devtool to upgrade from v1.1.0 to v1.2.0:
```bash
# In your Yocto build environment
devtool upgrade helloworld --version 1.2.0 --srcrev 381205a5486526f906c9e3b287f0b59cd5d5af85

# Or use the automation script
./upgrade_recipe_devtool.sh helloworld 1.2.0 381205a5486526f906c9e3b287f0b59cd5d5af85
```
