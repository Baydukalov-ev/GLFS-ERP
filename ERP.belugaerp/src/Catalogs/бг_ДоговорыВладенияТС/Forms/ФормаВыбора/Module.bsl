#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("Автомобиль") Тогда
		Список.Параметры.УстановитьЗначениеПараметра("ТранспортноеСредство", Параметры.Автомобиль);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

