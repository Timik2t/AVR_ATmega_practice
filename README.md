# AVR_ATmega_practice

## Описание проекта
Этот проект представляет собой набор различных задач, которые могут быть решены на микроконтроллере AVR ATmega. Он включает в себя различные практические упражнения и задания для работы с AVR-микроконтроллером в составе.
AVR Development Kit

## Технологии
* AVR Assembly
* AVR Studio

## Задачи
<details>
    <summary> 1. Работа с памятью EEPROM для сортировки массива.</summary>
        В ЕЕPROM расположен массив известной размерности (допустим 16 штук). Следует упорядочить элементы данного массива по возрастанию. При этом следует избежать лишних записей в ЕЕPROM. Все промежуточные вычисления стоит произвести в SRAM и записать в ЕЕPROM только массив-результат.
</details>

<details>
    <summary> 2. Использование прерываний для управления светодиодами.</summary>
        По прерыванию от переполнения Т\С1 происходит зажигание светодиодов, соответствующее содержимому Т\С0 на этот момент. Если в течение времени, соответствующего наступлению 2-х следующих прерываний от переполнения Т\С1 кнопками не будет набрана комбинация, соответствующая горящим светодиодам, то на период 4-х OVF T\C1 все светодиоды будут мигать, если она будет набрана, то на 3 периода OVF T\C1 все светодиоды гаснут. После этого тест повторяется заново. Кнопки с «памятью», т.е. набор комбинации на них предполагает нажатие и отпускание.
</details>

<details>
    <summary> 3. Установка связи и обмен данными между двумя устройствами через UART.</summary>
        Реализовать общение 2-х устройств по UART. На каждом STK задействованы 7 кнопок под данные и 1 под ввод. Если на STK1 нажимается некая комбинация данных и нажимается ввод, то эта комбинация передается в STK2 и высвечивается на его светодиодах. Если в свою очередь на STK2 набирается некая комбинация данных и нажимается ввод, то эта комбинация передается в STK1 и высвечивается уже на его светодиодах.
</details>

<details>
    <summary> 4. Разработка системы автоматической регулировки положения солнечной панели.</summary>
        Создать устройство регулирования положением солнечной батареи по максимуму освещенности. У нас есть элемент питания от калькулятора (солнечная батарея), двигатель от детской игрушки, ключи, которые позволяют коммутировать силовые цепи, АЦП AD7823.
</details>

### Автор
[Исхаков Тимур](https://github.com/Timik2t)
