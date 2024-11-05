#!/bin/bash

# Prompt for MySQL root password
echo "Define MySQL ROOT password."
echo -e "\033[32mEnter your desired password for root:\033[0m"
read -e -sp "" root_password
echo

# Update the package index
sudo apt update

# Install MySQL Server
sudo apt install -y mysql-server

# Secure MySQL Installation
sudo mysql_secure_installation <<EOF

y
y
$root_password
$root_password
y
y
y
y
EOF

# Change authentication method and set the password for root user
# Wait for MySQL to be fully initialized before running this
sleep 5

sudo mysql -u root -p"$root_password" <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '$root_password';
FLUSH PRIVILEGES;
CREATE DATABASE question_bank;
EOF

# Output MySQL connection parameters to .env file
if ! grep -q "MYSQL_USER=" .env; then
    echo "MYSQL_USER=root" >> .env
else
    sed -i 's/^MYSQL_USER=.*/MYSQL_USER=root/' .env
fi

if ! grep -q "MYSQL_PASSWORD=" .env; then
    echo "MYSQL_PASSWORD=$root_password" >> .env
else
    sed -i "s/^MYSQL_PASSWORD=.*/MYSQL_PASSWORD=$root_password/" .env
fi

if ! grep -q "MYSQL_DB=" .env; then
    echo "MYSQL_DB=question_bank" >> .env
else
    sed -i 's/^MYSQL_DB=.*/MYSQL_DB=question_bank/' .env
fi

# Print success message for .env file
echo "MySQL connection parameters written to .env file."

# Connect to MySQL and create the questions table
sudo mysql -u root -p"$root_password" <<EOF
USE question_bank;

CREATE TABLE IF NOT EXISTS questions(
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    question TEXT,
    type ENUM(
        'Java Core',
        'Java 8',
        'Design Patterns',
        'JDBC, Hibernate, Database',
        'Spring',
        'Microservices',
        'Optional - JavaScript',
        'Optional - Angular',
        'Optional - React',
        'Unknown'
    ) DEFAULT 'Unknown',
    attention ENUM('Newly added', 'Important', 'Normal') DEFAULT 'Normal',
    is_prioritized BOOLEAN DEFAULT FALSE,
    is_answered BOOLEAN DEFAULT FALSE
);

INSERT INTO questions (question, type, attention, is_prioritized, is_answered) VALUES
('What is the SOLID principle?', 'Java Core', 'Important', FALSE, FALSE),
('What is OOP? Explain Inheritance, Encapsulation, Polymorphism, and', 'Java Core', 'Normal', FALSE, FALSE),
('What is the Is-a and Has-a relationship in Java?', 'Java Core', 'Normal', FALSE, FALSE),
('What are method overriding and method overloading? Provide your own example', 'Java Core', 'Normal', FALSE, FALSE),
('Difference between interface and abstract class', 'Java Core', 'Normal', FALSE, FALSE),
('What is the diamond problem? How can we solve the diamond problem?', 'Java Core', 'Normal', FALSE, FALSE),
('Is Java passing by value or passing by reference?', 'Java Core', 'Normal', FALSE, FALSE),
('Difference between Array and ArrayList', 'Java Core', 'Normal', FALSE, FALSE),
('Difference between ArrayList and LinkedList', 'Java Core', 'Normal', FALSE, FALSE),
('What is an immutable class? How to create an immutable class?', 'Java Core', 'Important', FALSE, FALSE),
('Why is String immutable?', 'Java Core', 'Important', FALSE, FALSE),
('Difference between == and equals()', 'Java Core', 'Normal', FALSE, FALSE),
('Difference between String, StringBuilder, and StringBuffer', 'Java Core', 'Normal', FALSE, FALSE),
('Difference between default and protected access modifier', 'Java Core', 'Normal', FALSE, FALSE),
('How does HashMap work internally?', 'Java Core', 'Important', FALSE, FALSE),
('How does HashSet work internally?', 'Java Core', 'Important', FALSE, FALSE),
('Difference between HashMap, SynchronizedMap, and ConcurrentHashMap', 'Java Core', 'Important', FALSE, FALSE),
('Difference between List, Set, Map, Queue', 'Java Core', 'Normal', FALSE, FALSE),
('What are the types of Exceptions?', 'Java Core', 'Normal', FALSE, FALSE),
('How do you handle exceptions in Java?', 'Java Core', 'Normal', FALSE, FALSE),
('How do you handle exceptions in your web application?', 'Java Core', 'Important', FALSE, FALSE),
('Explain about Exception Propagation', 'Java Core', 'Normal', FALSE, FALSE),
('How to create customized exceptions?', 'Java Core', 'Normal', FALSE, FALSE),
('The difference between final, finally, and finalized', 'Java Core', 'Normal', FALSE, FALSE),
('How to create a thread?', 'Java Core', 'Normal', FALSE, FALSE),
('The difference between Runnable and Callable', 'Java Core', 'Normal', FALSE, FALSE),
('Why wait() and notify() in the Object class but not in the Thread Class', 'Java Core', 'Normal', FALSE, FALSE),
('What is join()?', 'Java Core', 'Normal', FALSE, FALSE),
('Explain the thread life cycle', 'Java Core', 'Normal', FALSE, FALSE),
('Difference between sleep() and wait()', 'Java Core', 'Normal', FALSE, FALSE),
('What is countDownLatch?', 'Java Core', 'Normal', FALSE, FALSE),
('What is a semaphore?', 'Java Core', 'Normal', FALSE, FALSE),
('Difference between Future and CompletableFuture', 'Java Core', 'Normal', FALSE, FALSE),
('The advantage of executor service instead of just creating a thread and running it', 'Java Core', 'Normal', FALSE, FALSE),
('What is a deadlock? How to handle deadlock?', 'Java Core', 'Normal', FALSE, FALSE),
('What is synchronization? How do you do synchronization?', 'Java Core', 'Important', FALSE, FALSE),
('What is readWriteLock?', 'Java Core', 'Normal', FALSE, FALSE),
('What is a marker interface? Provide an example and explain how it works.', 'Java Core', 'Important', FALSE, FALSE),
('What does Serialization mean by Serialization?', 'Java Core', 'Normal', FALSE, FALSE),
('What''s the purpose of transient variables?', 'Java Core', 'Normal', FALSE, FALSE),
('How do you do serialization and deserialization?', 'Java Core', 'Normal', FALSE, FALSE),
('What is a memory leak?', 'Java Core', 'Normal', FALSE, FALSE),
('What are the Young Generation, the Old Generation, and PermGen/MetaSpace?', 'Java Core', 'Newly added', FALSE, FALSE),
('What are the components of JVM?', 'Java Core', 'Normal', FALSE, FALSE),

('Have you used Java 8? What features are you familiar with?', 'Java 8', 'Important', TRUE, FALSE),
('What is the lambda expression?', 'Java 8', 'Important', TRUE, FALSE),
('What is the functional Interface? \nFollow Up: Is @FunctionalInterface annotation required?', 'Java 8', 'Important', TRUE, FALSE),
('How do lambda expressions and functional interfaces work together? Provide your own example of implementing a functional interface using a lambda expression.', 'Java 8', 'Important', TRUE, FALSE),
('Comparator vs Comparable', 'Java 8', 'Newly added', TRUE, FALSE),
('What is stream API in Java 8?', 'Java 8', 'Important', TRUE, FALSE),
('What is terminal operation and what is intermediate operation? Name some operations that you used.', 'Java 8', 'Important', TRUE, FALSE),
('Differences between stream and collection.', 'Java 8', 'Important', TRUE, FALSE),
('Is stream API sequential or parallel? How do we do parallel streams?', 'Java 8', 'Newly added', TRUE, FALSE),
('What is flatMap?', 'Java 8', 'Newly added', TRUE, FALSE),
('What is the default method and what is the static method?', 'Java 8', 'Important', TRUE, FALSE),
('What is Optional in Java 8?', 'Java 8', 'Important', TRUE, FALSE),

('What design patterns have you used?', 'Design Patterns', 'Important', TRUE, FALSE),
('What is the Singleton Design Pattern?', 'Design Patterns', 'Important', TRUE, FALSE),
('How to create a singleton? (eager initialization and lazy initialization) Please provide an implementation.', 'Design Patterns', 'Important', TRUE, FALSE),
('Is the Singleton thread-safe?', 'Design Patterns', 'Important', TRUE, FALSE),
('How to make a singleton thread safe? (for both eager and lazy)', 'Design Patterns', 'Important', TRUE, FALSE),
('How to prevent the Singleton Pattern from Reflection, Serialization and Cloning?', 'Design Patterns', 'Important', TRUE, FALSE),
('What is the factory design pattern? Why do we use factories? How do you use this design pattern in your application?', 'Design Patterns', 'Important', TRUE, FALSE),
('Provide a code example for a factory design pattern', 'Design Patterns', 'Important', TRUE, FALSE),
('Difference between factory vs. abstract factory design pattern', 'Design Patterns', 'Important', TRUE, FALSE),
('Provide a code example for the builder design pattern', 'Design Patterns', 'Important', TRUE, FALSE),
('Explain the API gateway design pattern', 'Microservices', 'Newly added', TRUE, FALSE),
('Explain the circuit breaker design pattern', 'Microservices', 'Newly added', TRUE, FALSE),
('Explain the proxy design pattern', 'Design Patterns', 'Normal', FALSE, FALSE),
('Explain the Observer design pattern', 'Design Patterns', 'Normal', FALSE, FALSE),
('Explain the Chain of Responsibility design pattern', 'Design Patterns', 'Normal', FALSE, FALSE),

('What is SQL Injection? How to solve it?', 'JDBC, Hibernate, Database', 'Important', TRUE, FALSE),
('Difference between Statement and PreparedStatement', 'JDBC, Hibernate, Database', 'Normal', TRUE, FALSE),
('What are JDBC statements? List the types of JDBC statements and their usage.', 'JDBC, Hibernate, Database', 'Newly added', TRUE, FALSE),
('What is JdbcTemplate? And what are some of the advantages it has over standard JDBC?', 'JDBC, Hibernate, Database', 'Newly added', FALSE, FALSE),
('How to handle transactions manually in JDBC?', 'JDBC, Hibernate, Database', 'Normal', FALSE, FALSE),
('What is ORM and what are its benefits?', 'JDBC, Hibernate, Database', 'Normal', TRUE, FALSE),
('What is Hibernate? How to configure Hibernate?\nFollow-up: If we want to migrate from MySQL to OracleDB, what is the one configuration property that we need to change other than the database URL, driver, username, and password?\nFollow-up: What is the difference between dialect and driver class?', 'JDBC, Hibernate, Database', 'Newly added', TRUE, FALSE),
('What is Session and SessionFactory in Hibernate?\nFollow-up: Is the session in Hibernate thread safe?', 'JDBC, Hibernate, Database', 'Normal', FALSE, FALSE),
('Difference between getCurrentSession vs. OpenSession', 'JDBC, Hibernate, Database', 'Normal', FALSE, FALSE),
('What are the three Hibernate entity states?', 'JDBC, Hibernate, Database', 'Newly added', FALSE, FALSE),
('Difference between get() vs. load()', 'JDBC, Hibernate, Database', 'Important', TRUE, FALSE),
('Difference between update, merge, saveOrUpdate', 'JDBC, Hibernate, Database', 'Important', TRUE, FALSE),
('Why do we use flush(), clear(), and commit?', 'JDBC, Hibernate, Database', 'Newly added', TRUE, FALSE),
('How to do Many-to-Many mapping in Hibernate', 'JDBC, Hibernate, Database', 'Normal', FALSE, FALSE),
('Give an example with @ManyToOne and @OneToMany', 'JDBC, Hibernate, Database', 'Normal', FALSE, FALSE),
('Fetching strategy in Hibernate\nFollow-up: What is lazy fetching?\nFollow-up: What is LazyInitializationException?\nFollow-up: How to prevent LazyInitializationException?', 'JDBC, Hibernate, Database', 'Important', TRUE, FALSE),
('Why is Hibernate often preferred over JDBC?', 'JDBC, Hibernate, Database', 'Important', TRUE, FALSE),
('What is HQL and what are the Criteria? What is type safe?', 'JDBC, Hibernate, Database', 'Normal', FALSE, FALSE),
('Caching in Hibernate/What are first-level cache and second-level cache and how are they accessed?\nFollow-up: If the second-level cache is enabled, how are the caches accessed (the order) when trying to fetch an entity?', 'JDBC, Hibernate, Database', 'Normal', TRUE, FALSE),
('Explain ACID', 'JDBC, Hibernate, Database', 'Important', TRUE, FALSE),
('Given an Employee table with ID, Department, and Salary, write a SQL query for the following:\nFollow-up: Find the number of employees in each department.\nFollow-up: Get the highest salary per department group.\nFollow-up: Find the employees who have the top salary in each department.\nFollow-up: Find all employees with the 3rd highest salary.', 'JDBC, Hibernate, Database', 'Newly added', TRUE, FALSE),
('Explain SQL vs NoSQL databases\nWhen do you choose to use Relational DB and when to use Non-Relational DB?', 'JDBC, Hibernate, Database', 'Important', TRUE, FALSE),
('What are inner join, left join, and right join?', 'JDBC, Hibernate, Database', 'Important', TRUE, FALSE),
('What is CTE?', 'JDBC, Hibernate, Database', 'Newly added', TRUE, FALSE),
('Explain the Stored Procedure and Trigger.', 'JDBC, Hibernate, Database', 'Newly added', TRUE, FALSE),
('What are the differences between a clustered index and a non-clustered index?', 'JDBC, Hibernate, Database', 'Newly added', TRUE, FALSE),
('What does the window function do? What are the differences between rank() and dense_rank()', 'JDBC, Hibernate, Database', 'Newly added', TRUE, FALSE),
('Based on insights from our monitoring tools indicating slow query performance, what strategies could be implemented to optimize it?', 'JDBC, Hibernate, Database', 'Newly added', TRUE, FALSE),
('Explain CAP\nFollow-up: Is MongoDB CP or AP?', 'JDBC, Hibernate, Database', 'Important', TRUE, FALSE),
('What are the two locking types in databases?', 'JDBC, Hibernate, Database', 'Newly added', TRUE, FALSE),

('Difference between the Spring framework and Spring Boot', 'Spring', 'Important', TRUE, FALSE),
('What is dependency injection? Why do we need dependency injection? How does the spring IOC container work?', 'Spring', 'Important', TRUE, FALSE),
('How to inject beans in spring? - important, prioritized \nFollow-up: Setter vs. constructor injection \nFollow-up: How to make setter injection mandatory?', 'Spring', 'Important', TRUE, FALSE),
('How to reconfigure/create beans in spring?', 'Spring', 'Normal', FALSE, FALSE),
('Difference between BeanFactory and ApplicationContext?', 'Spring', 'Important', TRUE, FALSE),
('Describe bean scopes that are supported by spring - prioritized \nFollow-up: Singleton vs Prototype \nFollow-up: Is singleton bean thread safe? \nFollow-up: What is the default bean scope? \nFollow-up: How to define the scope of a spring bean?', 'Spring', 'Normal', TRUE, FALSE),
('Given a singleton bean A and a prototype bean B, how do we inject A into B? What will be the behaviors of the beans?', 'Spring', 'Newly added', TRUE, FALSE),
('Given a singleton bean A and a prototype bean B, how do we inject B into A? What will be the behaviors of the beans?', 'Spring', 'Newly added', TRUE, FALSE),
('What is your understanding of @Autowired? How does Spring know which bean to inject? What is the usage of @Qualifier?', 'Spring', 'Normal', TRUE, FALSE),
('What is circular dependency?', 'Spring', 'Important', TRUE, FALSE),
('What is the usage of @SpringBootApplication?', 'Spring', 'Important', TRUE, FALSE),
('What''s the difference between @Component, @Repository & @Service annotations in Spring?', 'Spring', 'Newly added', TRUE, FALSE),
('How can you handle transactions in spring boot', 'Spring', 'Important', TRUE, FALSE),
('Describe Spring MVC (Need to mention DispatcherServlet)', 'Spring', 'Normal', TRUE, FALSE),
('What is ViewResolver in Spring?', 'Spring', 'Newly added', TRUE, FALSE),
('Difference between @Controller and @RestController', 'Spring', 'Normal', TRUE, FALSE),
('What is RestTemplate?', 'Spring', 'Newly added', TRUE, FALSE),
('@RequestBody vs. @ResponseBody', 'Spring', 'Normal', TRUE, FALSE),
('@PathVariable vs. @RequestParam', 'Spring', 'Important', TRUE, FALSE),
('How do you use Spring Repository?', 'Spring', 'Normal', FALSE, FALSE),
('What are the different kinds of HTTP methods - important \nFollow-up: Difference between POST vs PUT vs PATCH', 'Spring', 'Important', FALSE, FALSE),
('Difference between SOAP vs. REST', 'Spring', 'Normal', FALSE, FALSE),
('Is REST stateless?', 'Spring', 'Normal', TRUE, FALSE),
('Describe the RESTful principles.', 'Spring', 'Newly added', TRUE, FALSE),
('How to validate the values of a request body? - newly added, prioritized \nFollow-up: How does BindingResult work?', 'Spring', 'Newly added', TRUE, FALSE),
('How to maintain user logged-in using REST service', 'Spring', 'Important', TRUE, FALSE),
('What is Spring AOP?', 'Spring', 'Important', TRUE, FALSE),
('Talk about Spring Security', 'Spring', 'Important', TRUE, FALSE),
('How is JWT used with Spring Security?', 'Spring', 'Normal', TRUE, FALSE),
('What is unit testing vs integration testing?', 'Spring', 'Newly added', TRUE, FALSE),
('What do you use for testing? (Mockito)', 'Spring', 'Important', TRUE, FALSE),
('Describe some common annotations of Mockito.', 'Spring', 'Newly added', TRUE, FALSE),
('What is the difference between doReturn and thenReturn?', 'Spring', 'Normal', FALSE, FALSE),
('What are some tools that can be used to view test code coverage?', 'Spring', 'Newly added', TRUE, FALSE),
('What annotation do you use to quickly switch between different environments to load different configurations?', 'Spring', 'Newly added', TRUE, FALSE),
('What is Jasypt?', 'Spring', 'Newly added', TRUE, FALSE),

('Difference between Monolithic vs. Microservice \nFollow-up: Advantages and Disadvantages of Monoliths vs Microservices', 'Microservices', 'Important', TRUE, FALSE),
('What is cascading failure? How to prevent this failure?', 'Microservices', 'Important', TRUE, FALSE),
('What is fault tolerance? How to make your microservice fault-tolerant?', 'Microservices', 'Important', TRUE, FALSE),
('How do microservices communicate?', 'Microservices', 'Normal', TRUE, FALSE),
('What is Swagger?', 'Microservices', 'Normal', FALSE, FALSE),
('How do you monitor your application?', 'Microservices', 'Normal', TRUE, FALSE),
('Why do we need a gateway? Is a gateway necessary?', 'Microservices', 'Normal', TRUE, FALSE),
('How many environments can your application have?', 'Microservices', 'Normal', FALSE, FALSE),
('How do you employ your application? (IntelliJ -> GitHub -> Jenkins/GitAction -> Docker Hub -> Kubernetes -> AWS EC2/AWS EKS)', 'Microservices', 'Important', TRUE, FALSE),
('Usage of Jenkins. (Please look at the CI/CD guide on the training portal under day 35)', 'Microservices', 'Important', TRUE, FALSE),
('Describe your microservice architecture (candidates were asked to draw the architecture during the interview)', 'Microservices', 'Important', TRUE, FALSE),
('How to debug your microservice? (In other words, how to troubleshoot when there is an error in the microservice application?)', 'Microservices', 'Normal', TRUE, FALSE),
('How do you implement async in web applications?', 'Microservices', 'Important', TRUE, FALSE),
('What is RabbitMQ and what can it help us to achieve in a web application?', 'Microservices', 'Newly added', TRUE, FALSE),
('What are the components of RabbitMQ? Describe the role of each component.', 'Microservices', 'Newly added', TRUE, FALSE),
('What are the different types of exchanges that exist in RabbitMQ? Explain each exchange.', 'Microservices', 'Newly added', TRUE, FALSE),
('What is a dead letter exchange (DLX)?', 'Microservices', 'Newly added', TRUE, FALSE),
('How to secure your endpoint? (In other words, How can you check if an HTTP call is valid in microservices?)', 'Microservices', 'Important', TRUE, FALSE),
('Where do you store your configuration file when you use microservices?', 'Microservices', 'Important', TRUE, FALSE),
('How did you do user authorization in microservices', 'Microservices', 'Important', TRUE, FALSE),
('Vertical Scaling and Horizontal scaling in your application', 'Microservices', 'Important', TRUE, FALSE),
('Tell me about your experience with Cloud Service. Ex. AWS, GCP, Azure', 'Microservices', 'Important', TRUE, FALSE),
('What is Kafka? What is Kafka Stream? - important \nFollow-up: What are the components of Kafka? \nFollow-up: What is the purpose of partition and can you have multiple consumers listen to one partition?', 'Microservices', 'Important', FALSE, FALSE),
('What is ELK? (Please look at the guide on the training portal under day 35)', 'Microservices', 'Important', TRUE, FALSE),
('Explain distributed database management (2-phase commit, SAGA)', 'Microservices', 'Newly added', TRUE, FALSE),
('What is Event-driven development?', 'Microservices', 'Newly added', TRUE, FALSE),
('How do you use SAGA to achieve transaction management in a distributed system?', 'Microservices', 'Newly added', TRUE, FALSE),
('Explain your Microservices from end to end, how does a request go from frontend to database and come back?', 'Microservices', 'Important', TRUE, FALSE),
('Explain the components needed when designing a Microservices application.', 'Microservices', 'Important', TRUE, FALSE),

('What is EC6?', 'Optional - JavaScript', 'Normal', FALSE, FALSE),
('What is Hoisting?', 'Optional - JavaScript', 'Normal', FALSE, FALSE),
('What are the differences between Var, Let, and Const?', 'Optional - JavaScript', 'Normal', FALSE, FALSE),
('What is the difference between == and ===?', 'Optional - JavaScript', 'Normal', FALSE, FALSE),
('How does JavaScript compile?', 'Optional - JavaScript', 'Normal', FALSE, FALSE),
('What does “this” refer to?', 'Optional - JavaScript', 'Normal', FALSE, FALSE),
('What are JavaScript Scopes?', 'Optional - JavaScript', 'Normal', FALSE, FALSE),
('What is closure in JavaScript?', 'Optional - JavaScript', 'Normal', FALSE, FALSE),
('What is Callback Hell?', 'Optional - JavaScript', 'Normal', FALSE, FALSE),
('What is a Promise?', 'Optional - JavaScript', 'Normal', FALSE, FALSE),
('What are some new features introduced with ES6?', 'Optional - JavaScript', 'Normal', FALSE, FALSE),
('What is Event Propagation?', 'Optional - JavaScript', 'Normal', FALSE, FALSE),
('What is event.preventDefault?', 'Optional - JavaScript', 'Normal', FALSE, FALSE),
('Is JavaScript a single or multithreaded language?', 'Optional - JavaScript', 'Normal', FALSE, FALSE),
('What is the Event Loop?', 'Optional - JavaScript', 'Normal', FALSE, FALSE),
('What do call stack and callback queue do?', 'Optional - JavaScript', 'Normal', FALSE, FALSE),
('How does JavaScript compile?', 'Optional - JavaScript', 'Normal', FALSE, FALSE),
('What does it mean when we say that JavaScript is a Dynamically Typed Language?', 'Optional - JavaScript', 'Normal', FALSE, FALSE),
('What are some benefits of using Typescript?', 'Optional - JavaScript', 'Normal', FALSE, FALSE),
('What is Static Type Checking?', 'Optional - JavaScript', 'Normal', FALSE, FALSE),
('What is an Interface in Typescript?', 'Optional - JavaScript', 'Normal', FALSE, FALSE),
('What is the difference between type “any” and type “unknown”?', 'Optional - JavaScript', 'Normal', FALSE, FALSE),

('What is Angular?', 'Optional - Angular', 'Normal', FALSE, FALSE),
('What are Structural Directives? Can you give examples?', 'Optional - Angular', 'Normal', FALSE, FALSE),
('How does Angular bootstrap your application?', 'Optional - Angular', 'Normal', FALSE, FALSE),
('What is the Shadow DOM?', 'Optional - Angular', 'Normal', FALSE, FALSE),
('What is an HTTP Interceptor? What are some keywords?', 'Optional - Angular', 'Normal', FALSE, FALSE),
('What is the difference between Reactive and Template Driven Forms?', 'Optional - Angular', 'Normal', FALSE, FALSE),
('How are Directives different from Components?', 'Optional - Angular', 'Normal', FALSE, FALSE),
('What makes up an Angular View?', 'Optional - Angular', 'Normal', FALSE, FALSE),
('How can we handle routing in our Angular applications?', 'Optional - Angular', 'Normal', FALSE, FALSE),
('What is FormBuilder?', 'Optional - Angular', 'Normal', FALSE, FALSE),
('Explain each keyword used in NgModule.', 'Optional - Angular', 'Normal', FALSE, FALSE),
('What is a Service and Dependency Injection?', 'Optional - Angular', 'Normal', FALSE, FALSE),
('How is an Observable different from a Promise?', 'Optional - Angular', 'Normal', FALSE, FALSE),
('What is a Pipe?', 'Optional - Angular', 'Normal', FALSE, FALSE),
('How can we protect our routes when users are not logged in?', 'Optional - Angular', 'Normal', FALSE, FALSE),
('What is a BehaviorSubject?', 'Optional - Angular', 'Normal', FALSE, FALSE),
('How can we pass data between components?', 'Optional - Angular', 'Normal', FALSE, FALSE),
('How do we catch errors in Observables?', 'Optional - Angular', 'Normal', FALSE, FALSE),
('What is the default testing library in Angular? The test runner?', 'Optional - Angular', 'Normal', FALSE, FALSE),
('What is Property Binding?', 'Optional - Angular', 'Normal', FALSE, FALSE),
('How can we create custom Directives?', 'Optional - Angular', 'Normal', FALSE, FALSE),
('What is the file compilation order when an Angular application starts?', 'Optional - Angular', 'Normal', FALSE, FALSE),
('What is the purpose of the polyfills.ts file?', 'Optional - Angular', 'Normal', FALSE, FALSE),
('What is a Subject?', 'Optional - Angular', 'Normal', FALSE, FALSE),
('How can we emit values through Observables?', 'Optional - Angular', 'Normal', FALSE, FALSE),
('What is ngModel?', 'Optional - Angular', 'Normal', FALSE, FALSE),
('How can we make HTTP requests?', 'Optional - Angular', 'Normal', FALSE, FALSE),
('How can we conditionally render an element?', 'Optional - Angular', 'Normal', FALSE, FALSE),
('What is NgRx?', 'Optional - Angular', 'Normal', FALSE, FALSE),
('How is a Subject different from an Observable?', 'Optional - Angular', 'Normal', FALSE, FALSE),
('When does ngOnChanges run?', 'Optional - Angular', 'Normal', FALSE, FALSE),
('What is ChangeDetection? What are the different strategies?', 'Optional - Angular', 'Normal', FALSE, FALSE),
('What are some benefits of Typescript?', 'Optional - Angular', 'Normal', FALSE, FALSE),
('What is the difference between ng-template, ng-container, and ng-content?', 'Optional - Angular', 'Normal', FALSE, FALSE),
('What is the difference between RxJS “of” and “from”?', 'Optional - Angular', 'Normal', FALSE, FALSE),
('What does the async pipe do?', 'Optional - Angular', 'Normal', FALSE, FALSE),
('What is a ReplaySubject?', 'Optional - Angular', 'Normal', FALSE, FALSE),
('What are some RxJS Operators?', 'Optional - Angular', 'Normal', FALSE, FALSE),

('What is JSX and how is it different from HTML and JavaScript?', 'Optional - React', 'Normal', FALSE, FALSE),
('Name some lifecycle methods', 'Optional - React', 'Normal', FALSE, FALSE),
('What are the differences between useCallback and useMemo?', 'Optional - React', 'Normal', FALSE, FALSE),
('Render function? What does it return?', 'Optional - React', 'Normal', FALSE, FALSE),
('What is a single-page application?', 'Optional - React', 'Normal', FALSE, FALSE),
('What is React Route Guard?', 'Optional - React', 'Normal', FALSE, FALSE),
('What are props and states? How do you pass data from parent to child and vice versa?', 'Optional - React', 'Normal', FALSE, FALSE),
('What is prop drilling? How do you prevent it?', 'Optional - React', 'Normal', FALSE, FALSE),
('What is context API?', 'Optional - React', 'Normal', FALSE, FALSE),
('What is React Redux?', 'Optional - React', 'Normal', FALSE, FALSE),
('What are React components?', 'Optional - React', 'Normal', FALSE, FALSE),
('What are hooks?', 'Optional - React', 'Normal', FALSE, FALSE),
('What do useState, useEffect, useContext?', 'Optional - React', 'Normal', FALSE, FALSE),
('What is a ref in React?', 'Optional - React', 'Normal', FALSE, FALSE),
('How do you make API calls to the backend API?', 'Optional - React', 'Normal', FALSE, FALSE),
('How do you store data in the browser using React?', 'Optional - React', 'Normal', FALSE, FALSE),
('What is virtual DOM in React?', 'Optional - React', 'Normal', FALSE, FALSE);
EOF

# Print success message
echo "Database and table created successfully."

# Install required Python packages
pip install mysql-connector-python streamlit streamlit-option-menu python-dotenv
npm i bootstrap-icons

echo "Python dependencies installed successfully."

echo "Installation and configuration complete."

echo -e "\e[32m Running Streamlit application...\e[0m"

# Run the Python script using Streamlit
streamlit run question_generator.py
