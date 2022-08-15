# Домашнее задание к занятию "7.5. Основы golang"

С `golang` в рамках курса, мы будем работать не много, поэтому можно использовать любой IDE. 
Но рекомендуем ознакомиться с [GoLand](https://www.jetbrains.com/ru-ru/go/).  

## Задача 1. Установите golang.
1. Воспользуйтесь инструкций с официального сайта: [https://golang.org/](https://golang.org/).
2. Так же для тестирования кода можно использовать песочницу: [https://play.golang.org/](https://play.golang.org/).

Ответ:

```
Go установлен:

C:\Windows\system32>go version
go version go1.19 windows/amd64

C:\Windows\system32>
```

## Задача 2. Знакомство с gotour.
У Golang есть обучающая интерактивная консоль [https://tour.golang.org/](https://tour.golang.org/). 
Рекомендуется изучить максимальное количество примеров. В консоли уже написан необходимый код, 
осталось только с ним ознакомиться и поэкспериментировать как написано в инструкции в левой части экрана.  

Ответ:

```
Просмотрено
```


## Задача 3. Написание кода. 
Цель этого задания закрепить знания о базовом синтаксисе языка. Можно использовать редактор кода 
на своем компьютере, либо использовать песочницу: [https://play.golang.org/](https://play.golang.org/).

1. Напишите программу для перевода метров в футы (1 фут = 0.3048 метр). Можно запросить исходные данные 
у пользователя, а можно статически задать в коде.
    Для взаимодействия с пользователем можно использовать функцию `Scanf`:
    ```
    package main
    
    import "fmt"
    
    func main() {
        fmt.Print("Enter a number: ")
        var input float64
        fmt.Scanf("%f", &input)
    
        output := input * 2
    
        fmt.Println(output)    
    }
    ```
Ответ:
```
vagrant@server1:~/HW7.5$ cat zadacha3.go
package main

import "fmt"

func main() {
    fmt.Print("Enter a number of meters to convert to feet\nNumber of meters: ")
    var input float64
    fmt.Scanf("%f", &input)

    output := input * 0.3048

    fmt.Println(output)
}


vagrant@server1:~/HW7.5$ go run zadacha3.go
Enter a number of meters to convert to feet
Number of meters: 5
1.524
```
 
2. Напишите программу, которая найдет наименьший элемент в любом заданном списке, например:
    ```
    x := []int{48,96,86,68,57,82,63,70,37,34,83,27,19,97,9,17,}
    ```

Ответ:
```
vagrant@server1:~/HW7.5$ cat zadacha3.2.go
package main

import "fmt"

func main() {
    var xm = []int{48,96,86,68,57,82,63,70,37,34,83,27,19,97,9,17}
    iter := 0
    fmt.Println ("Вывод значений массива Х : ", xm)
    for i, x := range xm {
        if (i==0) {
           iter = x
        } else {
            if (x < iter){
                iter = x
            }
        }
    }

    fmt.Println("Минимальный элемент массива: ", iter)
}
vagrant@server1:~/HW7.5$

vagrant@server1:~/HW7.5$ go run zadacha3.2.go
Вывод значений массива Х :  [48 96 86 68 57 82 63 70 37 34 83 27 19 97 9 17]
Минимальный элемент массива:  9
```

3. Напишите программу, которая выводит числа от 1 до 100, которые делятся на 3. То есть `(3, 6, 9, …)`.

В виде решения ссылку на код или сам код. 


Ответ:

```
vagrant@server1:~/HW7.5$ cat zadacha3.3.go
package main

import "fmt"

func main() {
     for i := 1; i <= 100; i++ {
         if (i%3) == 0 {
             fmt.Print(i, " , ")
         }
    }
}

vagrant@server1:~/HW7.5$ go run zadacha3.3.go
3 , 6 , 9 , 12 , 15 , 18 , 21 , 24 , 27 , 30 , 33 , 36 , 39 , 42 , 45 , 48 , 51 , 54 , 57 , 60 , 63 , 66 , 69 , 72 , 75 , 78 , 81 , 84 , 87 , 90 , 93 , 96 , 99 , vagrant@server1:~/HW7.5$

```

## Задача 4. Протестировать код (не обязательно).

Создайте тесты для функций из предыдущего задания. 
```
Не выполнял
```
