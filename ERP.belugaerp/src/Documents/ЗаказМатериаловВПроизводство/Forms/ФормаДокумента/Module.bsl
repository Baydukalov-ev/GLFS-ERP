#Область ОбработчикиСобытийФормы

&НаСервере
Процедура бг_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	ИмяКоманды       = "бг_ОбеспечениеЗаполнитьСерииПоFIFO";
	ЗаголовокКоманды = НСтр("ru = 'Заполнить серии по FIFO';
	                        |en = 'Fill in series by FIFO'");
	бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьКнопкуНаФорму(ЭтотОбъект, ИмяКоманды,
								Элементы.ТоварыПодменюЗаполнить, ЗаголовокКоманды,
								ИмяКоманды, ИмяКоманды, , ВидКнопкиФормы.КнопкаКоманднойПанели);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура бг_ОбеспечениеЗаполнитьСерииПоFIFO(Команда)
	
	Если Не бг_ЗаполнитьСерииПоFIFOСервер() Тогда
		ТекстПредупреждения = НСтр("ru = 'В табличной части нет товаров, по которым серии можно заполнить по FIFO.';
								|en = 'The tabular section contains no goods that can be used to fill in series by FIFO.'");
		ПоказатьПредупреждение(Неопределено, ТекстПредупреждения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция бг_ЗаполнитьСерииПоFIFOСервер()
	
	Если бг_Номенклатура.ЕстьСтрокиДляЗаполненияСерийПоFIFO(Объект.Товары) Тогда
		
		бг_Номенклатура.ЗаполнитьСерииПоFIFOВТЧТовары(Объект, ПараметрыУказанияСерий);
		Модифицированность = Истина;
		
		Возврат Истина;
		
	Иначе
		
		Возврат Ложь;
		
	КонецЕсли;
	
КонецФункции

#КонецОбласти
