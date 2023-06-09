#Область ОбработчикиСобытийФормы

// Событие создания на сервере (может вызвать ошибку компиляции модуля)
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	ПриСозданииНаСервереУстановкаОбъекта(Отказ, СтандартнаяОбработка);
	ЗаполинитьДоступнуюСуммовуюСкидку();
	ЗаполинитьЦеныСоСкидкой();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Закрыть(Объект);
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПередУдалением(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Отказ = Истина;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// Команда сохранения результатов исполнения
&НаКлиенте
Процедура КомандаОК(Команда)
	Закрыть(ЭтаФорма.Объект);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлажки(Команда)
	Для каждого Строка Из Объект.Товары Цикл
		Строка.бг_РаспределятьСуммовуюСкидку = Истина;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажки(Команда)
	Для каждого Строка Из Объект.Товары Цикл
		Строка.бг_РаспределятьСуммовуюСкидку = Ложь;
	КонецЦикла;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Устанавливаем объект при установке на сервере
&НаСервере
Процедура ПриСозданииНаСервереУстановкаОбъекта(Отказ, СтандартнаяОбработка)
    Перем ПараметрОбъект;
    Если Параметры.Свойство("Объект", ПараметрОбъект) И ТипЗнч(ПараметрОбъект) = Тип("ДанныеФормыСтруктура") Тогда
        ЗначениеВДанныеФормы(
            ДанныеФормыВЗначение(
                Параметры.Объект, 
                ТипЗнч(РеквизитФормыВЗначение("Объект"))
            ), ЭтаФорма.Объект);                
    КонецЕсли; 
КонецПроцедуры

&НаСервере
Процедура ЗаполинитьДоступнуюСуммовуюСкидку()

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	МАКСИМУМ(бг_СуммовыеСкидкиСрезПоследних.СуммаСкидки) - СУММА(бг_СуммовыеСкидкиСрезПоследних.СуммаРезерва) КАК СуммоваяСкидка
	|ИЗ
	|	РегистрСведений.бг_СуммовыеСкидки.СрезПоследних(
	|			,
	|			Контрагент = &Контрагент
	|				И Регистратор <> &Регистратор) КАК бг_СуммовыеСкидкиСрезПоследних";
	
	Запрос.УстановитьПараметр("Контрагент", Объект.Контрагент);
	Запрос.УстановитьПараметр("Регистратор", Объект.Ссылка);
	
	УстановитьПривилегированныйРежим(Истина);
	Выборка = Запрос.Выполнить().Выбрать();
	УстановитьПривилегированныйРежим(Ложь);
	
	Если Выборка.Следующий() Тогда
		ДоступнаяСуммоваяСкидка = Выборка.СуммоваяСкидка;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ЗаполинитьЦеныСоСкидкой()

	Для каждого Строка Из Объект.Товары Цикл
		Строка.ЦенаСоСкидкой = Строка.Сумма / ?(Строка.Количество = 0, 1, Строка.Количество);
	КонецЦикла;

КонецПроцедуры

#КонецОбласти
