#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - Форма отчета.
//   КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
//   Настройки - Структура - см. возвращаемое значение ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию().
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	
	Настройки.События.ПриСозданииНаСервере = Истина;
	
КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//   ЭтаФорма             - ФормаКлиентскогоПриложения - Форма отчета.
//   Отказ                - Булево - Передается из параметров обработчика "как есть".
//   СтандартнаяОбработка - Булево - Передается из параметров обработчика "как есть".
//
// См. также:
//   "ФормаКлиентскогоПриложения.ПриСозданииНаСервере" в синтакс-помощнике.
//
Процедура ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка) Экспорт
	
	Параметры = ЭтаФорма.Параметры;
	ФормаПараметры = ЭтаФорма.ФормаПараметры;
	
	Если Параметры.Свойство("ПараметрКоманды") Тогда
		
		ФормаПараметры.КлючНазначенияИспользования = "ДвижениеМарокПоДокументу";
		ПараметрКоманды = Параметры.ПараметрКоманды;
		
		Если ТипЗнч(ПараметрКоманды) = Тип("ДокументСсылка.ЭтапПроизводства2_2")
			Или ТипЗнч(ПараметрКоманды) = Тип("ДокументСсылка.битОтражениеФактаПоПриходномуОрдеру")
			Или ТипЗнч(ПараметрКоманды) = Тип("ДокументСсылка.битОтражениеФактаПоРасходномуОрдеру")
			Или ТипЗнч(ПараметрКоманды) = Тип("ДокументСсылка.битПереупаковка")
			Или ТипЗнч(ПараметрКоманды) = Тип("ДокументСсылка.ТТНВходящаяЕГАИС")
			Или ТипЗнч(ПараметрКоманды) = Тип("ДокументСсылка.ТТНИсходящаяЕГАИС")
			Или ТипЗнч(ПараметрКоманды) = Тип("ДокументСсылка.АктСписанияЕГАИС")
			Или ТипЗнч(ПараметрКоманды) = Тип("ДокументСсылка.битИнвентаризацияПродукцииЕГАИС")
			Или ТипЗнч(ПараметрКоманды) = Тип("ДокументСсылка.битКомплектацияПродукцииЕГАИС") Тогда
			
			ФормаПараметры.Отбор.Вставить("Регистратор", ПараметрКоманды);
			
		ИначеЕсли ТипЗнч(ПараметрКоманды) = Тип("ДокументСсылка.битОтчетОПроизводствеЕГАИС") Тогда
			
			ДокументОснование = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПараметрКоманды, "ДокументОснование");
			ФормаПараметры.Отбор.Вставить("Регистратор", ДокументОснование);
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
