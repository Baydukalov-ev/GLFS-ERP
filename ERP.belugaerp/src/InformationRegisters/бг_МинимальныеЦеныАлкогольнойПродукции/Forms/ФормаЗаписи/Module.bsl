
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	КонтрольКрепости = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Запись.ВидАлкогольнойПродукции, "бг_КонтролироватьКрепость") = Истина;
	Если КонтрольКрепости Тогда
		ПроверяемыеРеквизиты.Добавить("Запись.Крепость");
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
