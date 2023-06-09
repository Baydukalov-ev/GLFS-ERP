
&Вместо("ОткрытьФормуВыбораАдресаИОбработатьРезультатЗавершение")
Процедура бг_ОткрытьФормуВыбораАдресаИОбработатьРезультатЗавершение(Результат, ДополнительныеПараметры)
	
	Элемент 					= ДополнительныеПараметры.Элемент;
	Объект 						= ДополнительныеПараметры.Объект;
	ИмяРеквизитаАдресаДоставки	= ДополнительныеПараметры.ИмяРеквизитаАдресаДоставки;
	
	Если ИмяРеквизитаАдресаДоставки = "бг_ОбособленныеПодразделения" Тогда
		НомерСтроки = ДополнительныеПараметры.НомерСтроки;
	КонецЕсли;

	Если ТипЗнч(Результат) = Тип("Структура") Тогда // КИ введена

		// Перенесем данные в форму
//#Вставка
		Если ИмяРеквизитаАдресаДоставки = "бг_ОбособленныеПодразделения" Тогда
			Объект[ИмяРеквизитаАдресаДоставки][НомерСтроки].Адрес = Результат.Представление;
			Объект[ИмяРеквизитаАдресаДоставки][НомерСтроки].АдресЗначенияПолей = Результат.КонтактнаяИнформация;
			Объект[ИмяРеквизитаАдресаДоставки][НомерСтроки].АдресЗначение = Результат.Значение;
		Иначе
//#КонецВставки
			Объект[ИмяРеквизитаАдресаДоставки + "ЗначенияПолей"] = Результат.КонтактнаяИнформация;
			Объект[ИмяРеквизитаАдресаДоставки + "Значение"] = Результат.Значение;
			Объект[ИмяРеквизитаАдресаДоставки] = Результат.Представление;
		КонецЕсли;

		// Установим признак модифицированности
		Родитель = Элемент.Родитель;
		Пока ТипЗнч(Родитель) <> Тип("ФормаКлиентскогоПриложения") Цикл
			Родитель = Родитель.Родитель;
		КонецЦикла;

		Если Родитель.ИмяФормы <> "Обработка.РабочееМестоМенеджераПоДоставке.Форма.Форма" Тогда
			Родитель.Модифицированность = Истина;
		КонецЕсли;
		Родитель.ОбновитьОтображениеДанных();

	КонецЕсли;

КонецПроцедуры
