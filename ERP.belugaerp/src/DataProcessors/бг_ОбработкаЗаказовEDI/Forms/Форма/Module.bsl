
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не ЭтотОбъект.Параметры.Свойство("ОбъектыНазначения")
		Или Не ЗначениеЗаполнено(ЭтотОбъект.Параметры.ОбъектыНазначения) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Обработка = РеквизитФормыВЗначение("Объект");
	Обработка.ЗаполнитьСписокДокументов(ЭтотОбъект.Параметры.ОбъектыНазначения);
	
	ЗначениеВРеквизитФормы(Обработка, "Объект");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	РезультатОбработки = ОбработатьЗаказы();
	
	Если Не ЗначениеЗаполнено(РезультатОбработки) Тогда
		ПоказатьПредупреждение( , НСтр("ru = 'Не удалось обработать заказы. См. служебные сообщения'"));
	ИначеЕсли Не РезультатОбработки.Свойство("ЕстьОшибки")
		Или РезультатОбработки.ЕстьОшибки = Ложь Тогда
		ПоказатьОповещениеПользователя(НСтр("ru = 'Обработка заказов завершена'"));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ОбработатьЗаказы()
	
	Результат = Новый Структура;
	
	Если Объект.Заказы.Количество() Тогда
		Обработка = РеквизитФормыВЗначение("Объект");
		Обработка.ОбработатьЗаказыEDI(Результат);
		ЗначениеВРеквизитФормы(Обработка, "Объект");
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти
